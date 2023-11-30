//
//  RecordRepository.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol RecordRepository{
    func fetchRoutineList() async throws
    func fetchRoutineRecords(routineId: UUID) async throws
    func fetchRoutineTopAcheives() async throws
    func fetchRoutineWeeklyTrakers() async throws
 
    var routineLists: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ get }
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?> { get }
    var routineTopAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ get }
}


final class RecordRepositoryImp: RecordRepository{
    
    var routineLists: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ routineListsSubject }
    private let routineListsSubject = CurrentValuePublisher<[RecordRoutineListModel]>([])
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ routineRecordsSubject }
    private let routineRecordsSubject = CurrentValuePublisher<RoutineRecordDatasModel?>( nil )
    
    var routineTopAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ routineTopAcheiveSubject }
    private let routineTopAcheiveSubject = CurrentValuePublisher<[RoutineTopAcheiveModel]>([])
    
    var routineWeeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ routineWeeksSubject }
    private let routineWeeksSubject = CurrentValuePublisher<[RoutineWeekRecordModel]>([])
        
    
    func fetchRoutineList() async throws {
        let routines = try routineReadModel.routineLists()
            .map(RecordRoutineListModel.init)
        
        routineListsSubject.send(routines)
        
        Log.v("Fetch RecordRoutines: \(routines)")
    }
    
    func fetchRoutineRecords(routineId: UUID) async throws{
        let records = try routineRecordReadModel.records(routineId: routineId)
        
        let today = Date()
        let totalRecord = try routineRecordReadModel.totalRecord(routineId: routineId)
        let monthRecord = try routineRecordReadModel.monthRecord(routineId: routineId, date: today)
        let weekRecord = try routineRecordReadModel.weekRecord(routineId: routineId, date: today)
        let topStreak = try routineRecordReadModel.topStreak(routineId: routineId)
        let currentStreak = try routineRecordReadModel.currentStreak(routineId: routineId, date: Date()) //Date -> now
        
        let model = RoutineRecordDatasModel(
            records: records,
            totalDto: totalRecord,
            monthDto: monthRecord,
            weekDto: weekRecord,
            bestStreak: topStreak,
            currentStreak: currentStreak
        )
                        
        routineRecordsSubject.send(model)
        Log.v("Fetch RoutineRecord: \(model)")
    }
    
    func fetchRoutineTopAcheives() async throws {
        let topAcheives = try routineRecordReadModel.topAcheive()
            .map(RoutineTopAcheiveModel.init)
        
        routineTopAcheiveSubject.send(topAcheives)
        
        Log.v("Fetch Routine TopAcheives: \(topAcheives)")
    }
    
    
    func fetchRoutineWeeklyTrakers() async throws {
        try await fetchRoutineList()
        
        let weeks = try routineRecordReadModel.weekRecords()
            .map(RoutineWeekRecordModel.init)
        routineWeeksSubject.send(weeks)
        Log.v("Fetch Routine WeeksRecord: \(weeks)")
    }
    
    
    func fetchTimerRecordLists() async throws {
        let records = try timerRecordReadModel.records(date: Date())
        Log.v("Fetch Timer RecordList: \(records)")
    }
    
    private let routineReadModel: RoutineReadModelFacade
    private let routineRecordReadModel: RoutineRecordReadModelFacade
    private let timerRecordReadModel: TimerRecordReadModelFacade
    
    init(
        routineReadModel: RoutineReadModelFacade,
        routineRecordReadMoel: RoutineRecordReadModelFacade,
        timerRecordReadModel: TimerRecordReadModelFacade
    ) {
        self.routineReadModel = routineReadModel
        self.routineRecordReadModel = routineRecordReadMoel
        self.timerRecordReadModel = timerRecordReadModel
    }
    
}
