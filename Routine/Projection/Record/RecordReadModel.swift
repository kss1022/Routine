//
//  RecordReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



protocol RoutineRecordReadModelFacade{
    func record(routineId: UUID, date: Date) throws -> RoutineRecordDto?
    func records(date: Date) throws -> [RoutineRecordDto]
    func records(routineId: UUID) throws -> [RoutineRecordDto]
    
    
    func totalRecord(routineId: UUID) throws -> RoutineTotalRecordDto?
    func monthRecord(routineId: UUID, date: Date) throws -> RoutineMonthRecordDto?
}


public final class RoutineRecordReadModelFacadeImp: RoutineRecordReadModelFacade{
    
    private let routineTotalRecordDao: RoutineTotalRecordDao
    private let routineMonthRecordDao: RoutineMonthRecordDao
    private let routineRecordDao: RoutineRecordDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        routineTotalRecordDao = dbManager.routineTotalRecordDao
        routineMonthRecordDao = dbManager.routineMonthRecordDao
        routineRecordDao = dbManager.routineRecordDao
    }
    
    
    func record(routineId: UUID, date: Date) throws -> RoutineRecordDto? {
        let date =  Formatter.recordDateFormatter().string(from: date)
        return try routineRecordDao.find(routineId: routineId, date: date)
    }
    
    func records(date: Date) throws -> [RoutineRecordDto] {
        let date =  Formatter.recordDateFormatter().string(from: date)
        return try routineRecordDao.findAll(date)
    }
    
    func records(routineId: UUID) throws -> [RoutineRecordDto] {
        try routineRecordDao.findAll(routineId)
    }
    
    func totalRecord(routineId: UUID) throws -> RoutineTotalRecordDto? {
        try routineTotalRecordDao.find(routineId: routineId)
    }
    
    func monthRecord(routineId: UUID, date: Date) throws -> RoutineMonthRecordDto? {
        let date = Formatter.recordMonthFormatter().string(from: date)
        return try routineMonthRecordDao.find(routineId: routineId, recordMonth: date)
    }

}
