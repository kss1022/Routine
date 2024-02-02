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
}

protocol RecordRoutineListPresentable: Presentable {
    var listener: RecordRoutineListPresentableListener? { get set }
    func setRoutineLists(_ viewModels : [RecordRoutineListViewModel])
    func showEmpty()
    func hideEmpty()
}

protocol RecordRoutineListListener: AnyObject {
    func recordRoutineTitleButtonDidTap()
    func recordRoutineListDidTap(routineId: UUID)
}

protocol RecordRoutineListInteractorDependency{
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RecordRoutineListInteractor: PresentableInteractor<RecordRoutineListPresentable>, RecordRoutineListInteractable, RecordRoutineListPresentableListener {

    weak var router: RecordRoutineListRouting?
    weak var listener: RecordRoutineListListener?

    private let dependency: RecordRoutineListInteractorDependency
    private let routineRecordRepository: RoutineRecordRepository
    
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RecordRoutineListPresentable,
        dependency: RecordRoutineListInteractorDependency
    ) {
        self.dependency = dependency
        self.routineRecordRepository = dependency.routineRecordRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{ [weak self] in
            try? await self?.routineRecordRepository.fetchList()
        }
        
        routineRecordRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                guard let self = self else { return }
                let viewModels = lists.map(RecordRoutineListViewModel.init)
                
                if viewModels.isEmpty{
                    self.presenter.showEmpty()
                }else{
                    self.presenter.hideEmpty()
                }
                
                self.presenter.setRoutineLists(viewModels)
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
