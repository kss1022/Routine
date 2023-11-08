//
//  RecordRepository.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol RecordRepository{
    func fetchRoutineRecords(routineId: UUID) async throws
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?> { get  }
}


final class RecordRepositoryImp: RecordRepository{
    
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ routineRecordsSubject }
    private var routineRecordsSubject = CurrentValuePublisher<RoutineRecordModel?>( nil )
    
    func fetchRoutineRecords(routineId: UUID) async throws{
        let records = try routineRecordReadMoel.records(routineId: routineId)
        
        let today = Date()
        let totalRecord = try routineRecordReadMoel.totalRecord(routineId: routineId)
        let monthRecord = try routineRecordReadMoel.monthRecord(routineId: routineId, date: today)
        
        let model = RoutineRecordModel(records: records, totalDto: totalRecord, monthDto: monthRecord)
        routineRecordsSubject.send(model)
        Log.v("Fetch RoutineRecord: \(routineId), \(records.count)")
    }
    
    func fetchTimerRecordLists() async throws {
        let records = try timerRecordReadModel.records(date: Date())
        Log.v("Fetch RecordList: \(records)")
    }
    
    private let routineRecordReadMoel: RoutineRecordReadModelFacade
    private let timerRecordReadModel: TimerRecordReadModelFacade
    
    init(
        routineRecordReadMoel: RoutineRecordReadModelFacade,
        timerRecordReadModel: TimerRecordReadModelFacade
    ) {
        self.routineRecordReadMoel = routineRecordReadMoel
        self.timerRecordReadModel = timerRecordReadModel
        
        Task{
            try? await fetchTimerRecordLists()
        }
        
    }
    
}
