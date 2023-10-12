//
//  RoutineListInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineListPresentable: Presentable {
    var listener: RoutineListPresentableListener? { get set }
    func setRoutineLists(viewModels : [RoutineListViewModel])
}

protocol RoutineListListener: AnyObject {
    func routineListDidTapRoutineDetail(routineId: UUID)
    func routineListDidComplete(list: RoutineHomeListModel)
}

protocol RoutineListInteractorDependency{
    var routineRepository: RoutineRepository{ get }    
}

final class RoutineListInteractor: PresentableInteractor<RoutineListPresentable>, RoutineListInteractable, RoutineListPresentableListener {

    weak var router: RoutineListRouting?
    weak var listener: RoutineListListener?
    
    private let dependency: RoutineListInteractorDependency
    private var cancelables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineListPresentable,
        dependency: RoutineListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancelables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.routineRepository.homeLists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                guard let self = self else { return }
                let viewModels = lists.map{ list in
                    RoutineListViewModel(list) {
                        self.listener?.routineListDidComplete(list: list)
                    }
                }
                self.presenter.setRoutineLists(viewModels: viewModels)
            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func routineListDidTap(_ routineId: UUID) {
        listener?.routineListDidTapRoutineDetail(routineId: routineId)
    }
}
