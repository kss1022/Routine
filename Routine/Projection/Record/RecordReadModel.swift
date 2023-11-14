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
    
    func topStreak(routineId: UUID) throws -> RoutineStreakDto?
    func currentStreak(routineId: UUID, date: Date) throws -> RoutineStreakDto?
    
    func topAcheive() throws -> [RoutineTopAcheiveDto]
    func weeklyTrackers(date: Date) throws -> [RoutineWeeklyTrackerDto]
}


public final class RoutineRecordReadModelFacadeImp: RoutineRecordReadModelFacade{
    
    private let routineTotalRecordDao: RoutineTotalRecordDao
    private let routineMonthRecordDao: RoutineMonthRecordDao
    private let routineWeekRecrodDao: RoutineWeekRecordDao
    private let routineStreakDao: RoutineStreakDao
    
    private let routineTopAcheiveDao: RoutineTopAcheiveDao
    private let routineWeeklyTrackerDao: RoutineWeeklyTrackerDao
    
    private let routineRecordDao: RoutineRecordDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        routineTotalRecordDao = dbManager.routineTotalRecordDao
        routineMonthRecordDao = dbManager.routineMonthRecordDao
        routineWeekRecrodDao = dbManager.routineWeekRecordDao
        routineStreakDao = dbManager.routineStreakDao
        
        routineTopAcheiveDao = dbManager.routineTopAcheiveDao
        routineWeeklyTrackerDao = dbManager.routineWeeklyTrackerDao
        
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
    
    func weekRecord(routineId: UUID, date: Date) throws -> RoutineWeekRecordDto? {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let weekOfYear = calendar.dateComponents([.weekOfYear], from: date).weekOfYear!
        return try routineWeekRecrodDao.find(routineId: routineId, year: year, weekOfYear: weekOfYear)
    }
    
    func topStreak(routineId: UUID) throws -> RoutineStreakDto? {
        return try routineStreakDao.topStreak(routineId: routineId)
    }
    
    func currentStreak(routineId: UUID, date: Date) throws -> RoutineStreakDto? {
        let date = Calendar.current.startOfDay(for: date)
        
        return try routineStreakDao.currentStreak(routineId: routineId, date: date)
    }
    
    func topAcheive() throws -> [RoutineTopAcheiveDto] {
        try routineTopAcheiveDao.find()
    }
    
    
    func weeklyTrackers(date: Date) throws -> [RoutineWeeklyTrackerDto] {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let weekOfYear = calendar.dateComponents([.weekOfYear], from: date).weekOfYear!
        return try routineWeeklyTrackerDao.find(year: year, weekOfYear: weekOfYear)
    }

}
