//
//  TimerDataInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs


protocol TimerDataRouting: ViewableRouting {
    func attachTimerDataOfYear()
    func attachTimerDatOfStats()
    func attachTimerTotalRecord()
}

protocol TimerDataPresentable: Presentable {
    var listener: TimerDataPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TimerDataListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func timerDataDidMove()
}

protocol TimerDataInteractorDependency{
    var timerRecordRepository: TimerRecordRepository{ get }
        
    var timerRecordsSubject:CurrentValuePublisher<[TimerRecordModel]>{ get }
    var timerMonthRecordsSubject: CurrentValuePublisher<[TimerMonthRecordModel]>{ get }
    var timerWeekRecordsSubject: CurrentValuePublisher<[TimerWeekRecordModel]>{ get }
    var timerSummeryModelSubject: CurrentValuePublisher<TimerSummeryModel?>{ get }
}

final class TimerDataInteractor: PresentableInteractor<TimerDataPresentable>, TimerDataInteractable, TimerDataPresentableListener {

    weak var router: TimerDataRouting?
    weak var listener: TimerDataListener?

    private let dependency: TimerDataInteractorDependency
    private let timerRecordRepository: TimerRecordRepository
    private let recordsSubject:CurrentValuePublisher<[TimerRecordModel]>
    private let monthRecordsSubject: CurrentValuePublisher<[TimerMonthRecordModel]>
    private let weekRecordsSubject: CurrentValuePublisher<[TimerWeekRecordModel]>
    private let timerSummeryModelSubject: CurrentValuePublisher<TimerSummeryModel?>
    
    private let timerId: UUID
    

    
    // in constructor.
    init(
        presenter: TimerDataPresentable,
        dependency: TimerDataInteractorDependency,
        timerId: UUID
    ) {
        self.dependency = dependency
        self.timerRecordRepository = dependency.timerRecordRepository
        self.recordsSubject = dependency.timerRecordsSubject
        self.monthRecordsSubject = dependency.timerMonthRecordsSubject
        self.weekRecordsSubject = dependency.timerWeekRecordsSubject
        self.timerSummeryModelSubject = dependency.timerSummeryModelSubject
        self.timerId = timerId
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await fetchRecords()
            }catch{
                Log.e("\(error)")
            }
        }
        
        router?.attachTimerDataOfYear()
        router?.attachTimerDatOfStats()
        router?.attachTimerTotalRecord()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMove() {
        listener?.timerDataDidMove()
    }
    
    
    private func fetchRecords() async throws{
        async let records = try await timerRecordRepository.records(timerId: timerId)
        async let monthRecords = try await timerRecordRepository.monthRecord(timerId: timerId)
        async let weekRecords = try await timerRecordRepository.weekRecord(timerId: timerId)
        async let totalRecord = try await timerRecordRepository.totalRecord(timerId: timerId)
        async let topStreak = try await timerRecordRepository.topStreak(timerId: timerId)
        async let currentStreak = try await timerRecordRepository.streak(timerId: timerId, date: Date()) //now
        
        recordsSubject.send(try await records)
        monthRecordsSubject.send(try await monthRecords)
        weekRecordsSubject.send(try await weekRecords)
                
        timerSummeryModelSubject.send(TimerSummeryModel(
            totalDone: try await totalRecord?.done ?? 0,
            totalTime: try await totalRecord?.time ?? 0,
            topStreak: try await topStreak?.streakCount ?? 0,
            currentStreak: try await currentStreak?.streakCount ?? 0
            )
        )
    }
}
