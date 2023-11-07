//
//  RecordRoutineListDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RecordRoutineListDetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordRoutineListDetailPresentable: Presentable {
    var listener: RecordRoutineListDetailPresentableListener? { get set }
    func setRoutineLists(viewModels : [RecordRoutineListViewModel])
}

protocol RecordRoutineListDetailListener: AnyObject {
    func recordRoutineListDetailDidMove()
}

protocol RecordRoutineListDetailInteractorDependency{
    var routineRepository: RoutineRepository{ get }
}

final class RecordRoutineListDetailInteractor: PresentableInteractor<RecordRoutineListDetailPresentable>, RecordRoutineListDetailInteractable, RecordRoutineListDetailPresentableListener {

    weak var router: RecordRoutineListDetailRouting?
    weak var listener: RecordRoutineListDetailListener?

    private let dependency: RecordRoutineListDetailInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RecordRoutineListDetailPresentable,
        dependency: RecordRoutineListDetailInteractorDependency
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
    
    func routineListDidTap(routineId: UUID) {
        Log.v("routineListDidTap")
    }
    
    func didMove() {
        listener?.recordRoutineListDetailDidMove()
    }

}
