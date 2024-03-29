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
}

protocol RoutineListPresentable: Presentable {
    var listener: RoutineListPresentableListener? { get set }
    func setRoutineLists(viewModels : [RoutineListViewModel])

    func showEmpty()
    func hideEmpty()
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
                    RoutineListViewModel(list) { [weak self] in
                        self?.listener?.routineListDidComplete(list: list)
                    }
                }
                
                if viewModels.isEmpty{
                    self.presenter.showEmpty()
                }else{
                    self.presenter.hideEmpty()
                }
                
                self.presenter.setRoutineLists(viewModels: viewModels)

            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()        
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func routineListDidTap(_ routineId: UUID) {
        listener?.routineListDidTapRoutineDetail(routineId: routineId)
    }
}
