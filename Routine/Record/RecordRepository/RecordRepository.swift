//
//  RecordRepository.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol RecordRepository{
    func fetchRoutineRecords(routineId: UUID) async throws
    func fetchRoutineTopAcheives() async throws
    func fetchRoutineWeeklyTrakers(date: Date) async throws
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?> { get }
    var routineTopAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
    var routineWeeklyTrackers: ReadOnlyCurrentValuePublisher<[RoutineWeeklyTrackerModel]>{ get }
}


final class RecordRepositoryImp: RecordRepository{
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ routineRecordsSubject }
    private let routineRecordsSubject = CurrentValuePublisher<RoutineRecordModel?>( nil )
    
    var routineTopAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ routineTopAcheiveSubject }
    private let routineTopAcheiveSubject = CurrentValuePublisher<[RoutineTopAcheiveModel]>([])
    
    var routineWeeklyTrackers: ReadOnlyCurrentValuePublisher<[RoutineWeeklyTrackerModel]>{ routineWeeklyTrackersSubject }
    private let routineWeeklyTrackersSubject = CurrentValuePublisher<[RoutineWeeklyTrackerModel]>([])
    
    func fetchRoutineRecords(routineId: UUID) async throws{
        let records = try routineRecordReadModel.records(routineId: routineId)
        
        let today = Date()
        let totalRecord = try routineRecordReadModel.totalRecord(routineId: routineId)
        let monthRecord = try routineRecordReadModel.monthRecord(routineId: routineId, date: today)
        let weekRecord = try routineRecordReadModel.weekRecord(routineId: routineId, date: today)
        
        let model = RoutineRecordModel(records: records, totalDto: totalRecord, monthDto: monthRecord, weekDto: weekRecord)
        routineRecordsSubject.send(model)
        Log.v("Fetch RoutineRecord: \(model)")
    }
    
    func fetchRoutineTopAcheives() async throws {
        let topAcheives = try routineRecordReadModel.topAcheive()
            .map(RoutineTopAcheiveModel.init)
        
        routineTopAcheiveSubject.send(topAcheives)
        
        Log.v("Fetch Routine TopAcheives: \(topAcheives)")
    }
    
    
    func fetchRoutineWeeklyTrakers(date: Date) async throws {
        let weeklyTrackers = try routineRecordReadModel.weeklyTrackers(date: date)
            .map(RoutineWeeklyTrackerModel.init)
        routineWeeklyTrackersSubject.send(weeklyTrackers)
        Log.v("Fetch FetchRoutineWeeklyTrakers: \(weeklyTrackers)")
    }
    
    
    func fetchTimerRecordLists() async throws {
        let records = try timerRecordReadModel.records(date: Date())
        Log.v("Fetch RecordList: \(records)")
    }
    
    private let routineRecordReadModel: RoutineRecordReadModelFacade
    private let timerRecordReadModel: TimerRecordReadModelFacade
    
    init(
        routineRecordReadMoel: RoutineRecordReadModelFacade,
        timerRecordReadModel: TimerRecordReadModelFacade
    ) {
        self.routineRecordReadModel = routineRecordReadMoel
        self.timerRecordReadModel = timerRecordReadModel
        
        Task{
            try? await fetchTimerRecordLists()
        }
        
    }
    
}
