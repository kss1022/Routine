//
//  RecordHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol RecordHomeRouting: ViewableRouting {
    
    func attachRecordRoutineListDetail()
    func detachRecordRoutineListDetail()
    
    func attachRoutineData()
    func detachRoutineData()
    
    func attachRecordBanner()
    func attachRecordRoutineList()
}

protocol RecordHomePresentable: Presentable {
    var listener: RecordHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RecordHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RecordHomeInteractorDependency{
    var recordRepository: RecordRepository{ get }
}

final class RecordHomeInteractor: PresentableInteractor<RecordHomePresentable>, RecordHomeInteractable, RecordHomePresentableListener {

    weak var router: RecordHomeRouting?
    weak var listener: RecordHomeListener?

    private let dependency: RecordHomeInteractorDependency
    
    // in constructor.
    init(
        presenter: RecordHomePresentable,
        dependency: RecordHomeInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        Log.v("Record Home DidBecome Active 🎥")
        router?.attachRecordBanner()
        router?.attachRecordRoutineList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    // MARK: RoutineData    
    func recordRoutineListDidTap(routineId: UUID) {
        Task{
            do{
                try await dependency.recordRepository.fetchRoutineRecords(routineId: routineId)
                await MainActor.run { router?.attachRoutineData() }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    func routineDataDidMove() {
        router?.detachRoutineData()
    }
        
    
    // MARK: RecordRoutineListDetail
    func recordRoutineTitleButtonDidTap() {
        router?.attachRecordRoutineListDetail()
    }
    

    func recordRoutineListDetailDidMove() {
        router?.detachRecordRoutineListDetail()
    }
}
