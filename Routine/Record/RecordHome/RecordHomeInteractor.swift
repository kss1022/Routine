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

final class RecordHomeInteractor: PresentableInteractor<RecordHomePresentable>, RecordHomeInteractable, RecordHomePresentableListener {

    weak var router: RecordHomeRouting?
    weak var listener: RecordHomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RecordHomePresentable) {
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
        router?.attachRoutineData()
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
