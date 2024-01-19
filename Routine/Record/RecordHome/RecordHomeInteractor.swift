//
//  RecordHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol RecordHomeRouting: ViewableRouting {
    
    func attachRoutineTopAcheive()
    func detachRoutineTopAcheive()
    
    func attachRoutineWeeklyTracker()
    func detachRoutineWeeklyTracker()
    
    func attachRecordRoutineListDetail()
    func detachRecordRoutineListDetail()
    
    func attachRecordTimerListDetail()
    func detachRecrodTimerListDetail()
    
    func attachRoutineData()
    func detachRoutineData()
    
    func attachTimerData()
    func detachTimerData()
    
    func attachRecordBanner()
    func attachRecordRoutineList()
    func attachRecordTimerList()
}

protocol RecordHomePresentable: Presentable {
    var listener: RecordHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RecordHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RecordHomeInteractorDependency{
    var routineRecordRepository: RoutineRecordRepository{ get }
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
        //router?.attachRecordTimerList() //TODO: Record of Timer
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: Banner
    func recordBannerDidTap(index: Int) {
        switch index{
        case 0:
            //Top Acheive
            Task{ [weak self] in
                guard let self = self else { return }
                do{
                    try await dependency.routineRecordRepository.fetchTopAcheives()
                    await MainActor.run { [weak self] in self?.router?.attachRoutineTopAcheive() }
                }catch{
                    Log.e("\(error)")
                }
            }
        case 1:
            //WeeklyTracker
            Task{ [weak self] in
                guard let self = self else { return }
                do{                    
                    try await dependency.routineRecordRepository.fetchWeeklyTrakers()
                    await MainActor.run { [weak self] in self?.router?.attachRoutineWeeklyTracker() }
                }catch{
                    Log.e("\(error)")
                }
            }
        case 2:
            //Case 2
            Log.v("BannerTap: Index 2")
        default : fatalError()
        }
    }
    
    func routineTopAcheiveDidMove() {
        router?.detachRoutineTopAcheive()
    }
    
    func routineWeeklyTrackerDidMove() {
        router?.detachRoutineWeeklyTracker()
    }
    
    
    // MARK: RoutineData    
    func recordRoutineListDidTap(routineId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineRecordRepository.fetchRecords(routineId: routineId)
                await MainActor.run { [weak self] in self?.router?.attachRoutineData() }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    func routineDataDidMove() {
        router?.detachRoutineData()
    }
        
    //MARK: TimerData
    func recordTimerListDidTap(timerId: UUID) {
        router?.attachTimerData()
    }
    
    func timerDataDidMove() {
        router?.detachTimerData()
    }
    
    // MARK: RecordRoutineListDetail
    func recordRoutineTitleButtonDidTap() {
        router?.attachRecordRoutineListDetail()
    }
    

    func recordRoutineListDetailDidMove() {
        router?.detachRecordRoutineListDetail()
    }
    
    //MARK: RecrodTimerListDetail
    func recordTimerListTitleButtonDidTap() {
        router?.attachRecordTimerListDetail()
    }
    
    
    func recordTimerListDetailDidMove() {
        router?.detachRecrodTimerListDetail()
    }

}
