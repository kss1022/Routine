//
//  TimerRecordRepository.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation





protocol TimerRecordRepository{
    var lists: ReadOnlyCurrentValuePublisher<[RecordTimerListModel]>{ get }
    
    func fetchList() async throws
        
    func records(timerId: UUID) async throws -> [TimerRecordModel]
    func totalRecord(timerId: UUID) async throws -> TimerTotalRecordModel?
    func monthRecord(timerId: UUID) async throws -> [TimerMonthRecordModel]
    func weekRecord(timerId: UUID) async throws -> [TimerWeekRecordModel]
    func topStreak(timerId: UUID) async throws -> TimerStreakModel?
    func streak(timerId: UUID, date: Date) async throws -> TimerStreakModel?
}


final class TimerRecordRepositoryImp: TimerRecordRepository{

    
    var lists: ReadOnlyCurrentValuePublisher<[RecordTimerListModel]>{ listsSubject}
    private let listsSubject = CurrentValuePublisher<[RecordTimerListModel]>([])
    
    
    func records(timerId: UUID) async throws -> [TimerRecordModel] {
        Log.v("TimerRecordRepository: fetch records")
        return try recordReadMoel.records(timerID: timerId).map(TimerRecordModel.init)
    }
    
    func totalRecord(timerId: UUID) async throws -> TimerTotalRecordModel? {
        Log.v("TimerRecordRepository: fetch totalRecord")
        return try recordReadMoel.totalRecord(timerId: timerId).map(TimerTotalRecordModel.init)
    }
    
    func monthRecord(timerId: UUID) async throws -> [TimerMonthRecordModel] {
        Log.v("TimerRecordRepository: fetch mothRecord")
        return try recordReadMoel.monthReords(timerId: timerId).map(TimerMonthRecordModel.init)
    }
    
    func weekRecord(timerId: UUID) async throws -> [TimerWeekRecordModel] {
        Log.v("TimerRecordRepository: fetch weekRecord")
        return try recordReadMoel.weekRecords(timerId: timerId).map(TimerWeekRecordModel.init)
    }
    
    func topStreak(timerId: UUID) async throws -> TimerStreakModel? {
        Log.v("TimerRecordRepository: fetch topStreak")
        return try recordReadMoel.topStreak(timerId: timerId).map(TimerStreakModel.init)
    }
    
    func streak(timerId: UUID, date: Date) async throws -> TimerStreakModel? {
        Log.v("TimerRecordRepository: fetch streak")
        return try recordReadMoel.streak(timerId: timerId, date: date).map(TimerStreakModel.init)
    }
    
    
    func fetchList() async throws {
        let timers = try timerReadModel.timerLists().map(RecordTimerListModel.init)
        listsSubject.send(timers)
        Log.v("TimerRecordRepository: fetch lists")
    }

    
    private let timerReadModel: TimerReadModelFacade
    private let recordReadMoel: TimerRecordReadModelFacade
    
    
    init(
        timerReadModel: TimerReadModelFacade,
        timerRecordReadModel: TimerRecordReadModelFacade
    ){
        self.timerReadModel = timerReadModel
        self.recordReadMoel = timerRecordReadModel
    }
}
