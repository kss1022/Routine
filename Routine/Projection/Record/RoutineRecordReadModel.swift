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
    func weekRecord(routineId: UUID, date: Date) throws -> RoutineWeekRecordDto?
    func weekRecords() throws -> [RoutineWeekRecordDto]

    func topStreak(routineId: UUID) throws -> RoutineStreakDto?
    func streak(routineId: UUID, date: Date) throws -> RoutineStreakDto?
    
    func topAcheive() throws -> [RoutineTopAcheiveDto]
}


public final class RoutineRecordReadModelFacadeImp: RoutineRecordReadModelFacade{
    private let routineTotalRecordDao: RoutineTotalRecordDao
    private let routineMonthRecordDao: RoutineMonthRecordDao
    private let routineWeekRecordDao: RoutineWeekRecordDao
    private let routineStreakDao: RoutineStreakDao
    private let routineTopAcheiveDao: RoutineTopAcheiveDao
    private let routineRecordDao: RoutineRecordDao
        
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        routineTotalRecordDao = dbManager.routineTotalRecordDao
        routineMonthRecordDao = dbManager.routineMonthRecordDao
        routineWeekRecordDao = dbManager.routineWeekRecordDao
        routineStreakDao = dbManager.routineStreakDao
        routineTopAcheiveDao = dbManager.routineTopAcheiveDao
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
        let month = Formatter.recordMonthFormatter().string(from: date)
        return try routineMonthRecordDao.find(routineId: routineId, recordMonth: month)
    }
    
    func weekRecord(routineId: UUID, date: Date) throws -> RoutineWeekRecordDto? {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)

        let startOfWeek = calendar.date(from: components)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                
        let strStartOfWeek = Formatter.weekRecordFormatter().string(from: startOfWeek)
        let strEndOfWeek = Formatter.weekRecordFormatter().string(from: endOfWeek)
        
        return try routineWeekRecordDao.find(routineId: routineId, startOfWeek: strStartOfWeek, endOfWeek: strEndOfWeek)
    }
    
    func weekRecords() throws -> [RoutineWeekRecordDto] {
        try routineWeekRecordDao.findAll()
    }
    
    func topStreak(routineId: UUID) throws -> RoutineStreakDto? {
        try routineStreakDao.topStreak(routineId: routineId)
    }
    
    func streak(routineId: UUID, date: Date) throws -> RoutineStreakDto? {
        let date = Calendar.current.startOfDay(for: date)
        return try routineStreakDao.findCurrentStreak(routineId: routineId, date: date)
    }
    
    func topAcheive() throws -> [RoutineTopAcheiveDto] {
        try routineTopAcheiveDao.find()
    }

}
