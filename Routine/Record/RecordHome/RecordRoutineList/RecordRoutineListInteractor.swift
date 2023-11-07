//
//  RecordRoutineListInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation
import ModernRIBs
import Combine


protocol RecordRoutineListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordRoutineListPresentable: Presentable {
    var listener: RecordRoutineListPresentableListener? { get set }
    func setRoutineLists(viewModels : [RecordRoutineListViewModel])
}

protocol RecordRoutineListListener: AnyObject {
    func recordRoutineTitleButtonDidTap()
    func recordRoutineListDidTap(routineId: UUID)
}

protocol RecordRoutineListInteractorDependency{
    var routineRepository: RoutineRepository{ get }
}

final class RecordRoutineListInteractor: PresentableInteractor<RecordRoutineListPresentable>, RecordRoutineListInteractable, RecordRoutineListPresentableListener {

    weak var router: RecordRoutineListRouting?
    weak var listener: RecordRoutineListListener?

    private let dependency: RecordRoutineListInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RecordRoutineListPresentable,
        dependency: RecordRoutineListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.routineRepository.homeLists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                guard let self = self else { return }
                let viewModels = lists.map(RecordRoutineListViewModel.init)
                self.presenter.setRoutineLists(viewModels: viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func titleButtonDidTap() {
        listener?.recordRoutineTitleButtonDidTap()
    }
    
    func routineListDidTap(routineId: UUID) {
        listener?.recordRoutineListDidTap(routineId: routineId)
    }
    
}
