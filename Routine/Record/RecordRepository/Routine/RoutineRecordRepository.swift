//
//  RecordRepository.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol RoutineRecordRepository{
    func fetchList() async throws
    func fetchRecords(routineId: UUID) async throws
    func fetchTopAcheives() async throws
    func fetchWeeklyTrakers() async throws
 
    var lists: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ get }
    var records: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?> { get }
    var topAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
    var weeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ get }
}


final class RoutineRecordRepositoryImp: RoutineRecordRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[RecordRoutineListModel]>{ listsSubject }
    private let listsSubject = CurrentValuePublisher<[RecordRoutineListModel]>([])
    
    var records: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ recordsSubject }
    private let recordsSubject = CurrentValuePublisher<RoutineRecordDatasModel?>( nil )
    
    var topAcheive: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ topAcheiveSubject }
    private let topAcheiveSubject = CurrentValuePublisher<[RoutineTopAcheiveModel]>([])
    
    var weeks: ReadOnlyCurrentValuePublisher<[RoutineWeekRecordModel]>{ weeksSubject }
    private let weeksSubject = CurrentValuePublisher<[RoutineWeekRecordModel]>([])
        
    
    func fetchList() async throws {
        let routines = try routineReadModel.routineLists()
            .map(RecordRoutineListModel.init)
        
        listsSubject.send(routines)
        
        Log.v("RoutineRecordRepository: fetch lists")
    }
    
    func fetchRecords(routineId: UUID) async throws{
        let records = try recordReadModel.records(routineId: routineId)
        
        let today = Date()
        let totalRecord = try recordReadModel.totalRecord(routineId: routineId)
        let monthRecord = try recordReadModel.monthRecord(routineId: routineId, date: today)
        let weekRecord = try recordReadModel.weekRecord(routineId: routineId, date: today)
        let topStreak = try recordReadModel.topStreak(routineId: routineId)
        let currentStreak = try recordReadModel.streak(routineId: routineId, date: Date()) //Date -> now
        
        let model = RoutineRecordDatasModel(
            records: records,
            totalDto: totalRecord,
            monthDto: monthRecord,
            weekDto: weekRecord,
            bestStreak: topStreak,
            currentStreak: currentStreak
        )
                        
        recordsSubject.send(model)
        Log.v("Fetch RoutineRecord: \(model)")
    }
    
    func fetchTopAcheives() async throws {
        let topAcheives = try recordReadModel.topAcheive()
            .map(RoutineTopAcheiveModel.init)
        
        topAcheiveSubject.send(topAcheives)
        
        Log.v("Fetch Routine TopAcheives: \(topAcheives)")
    }
    
    
    func fetchWeeklyTrakers() async throws {
        try await fetchList()
        
        let weeks = try recordReadModel.weekRecords()
            .map(RoutineWeekRecordModel.init)
        weeksSubject.send(weeks)
        Log.v("Fetch Routine WeeksRecord: \(weeks)")
    }
    

    
    private let routineReadModel: RoutineReadModelFacade
    private let recordReadModel: RoutineRecordReadModelFacade
    
    init(
        routineReadModel: RoutineReadModelFacade,
        recordReadModel: RoutineRecordReadModelFacade
    ){
        self.routineReadModel = routineReadModel
        self.recordReadModel = recordReadModel
    }
    
}
