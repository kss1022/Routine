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
    func attachRoutineData()
    func detachRoutineData()
}

protocol RecordRoutineListDetailPresentable: Presentable {
    var listener: RecordRoutineListDetailPresentableListener? { get set }
    func setRoutineLists(viewModels : [RecordRoutineListViewModel])
    func showEmpty()
    func hideEmpty()
}

protocol RecordRoutineListDetailListener: AnyObject {
    func recordRoutineListDetailDidMove()
}

protocol RecordRoutineListDetailInteractorDependency{
    var routineRepository: RoutineRepository{ get }
    var recordRepository: RecordRepository{ get }
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
        
        dependency.routineRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                guard let self = self else { return }
                let viewModels = lists.map(RecordRoutineListViewModel.init)
                
                if viewModels.isEmpty{
                    self.presenter.showEmpty()
                }else{
                    self.presenter.hideEmpty()
                }
                
                self.presenter.setRoutineLists(viewModels: viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    

    
    func didMove() {
        listener?.recordRoutineListDetailDidMove()
    }
    
    
    //MARK: RoutineData
    func routineListDidTap(routineId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.recordRepository.fetchRoutineRecords(routineId: routineId)
                await MainActor.run { [weak self] in self?.router?.attachRoutineData() }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    func routineDataDidMove() {
        router?.detachRoutineData()
    }

}
