//
//  TimerRecordReadModel.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




protocol TimerRecordReadModelFacade{
    func records(timerID: UUID) throws -> [TimerRecordDto]
    
    func totalRecord(timerId: UUID) throws -> TimerTotalRecordDto?
    func monthRecord(timerId: UUID, date: Date) throws -> TimerMonthRecordDto?
    func monthReords(timerId: UUID) throws -> [TimerMonthRecordDto]
    func weekRecord(timerId: UUID, date: Date) throws -> TimerWeekRecordDto?
    func weekRecords(timerId: UUID) throws -> [TimerWeekRecordDto]
    func topStreak(timerId: UUID) throws -> TimerStreakDto?
    func streak(timerId: UUID, date: Date) throws -> TimerStreakDto?
}


public final class TimerRecordReadModelFacadeImp: TimerRecordReadModelFacade{

    private let timerTotalRecordDao: TimerTotalRecordDao
    private let timerMonthRecordDao: TimerMonthRecordDao
    private let timerWeekRecordDao: TimerWeekRecordDao
    private let timerStreakDao: TimerStreakDao
    private let timerRecordDao: TimerRecordDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
                        
        timerTotalRecordDao = dbManager.timerTotalRecordDao
        timerMonthRecordDao = dbManager.timerMonthRecordDao
        timerWeekRecordDao = dbManager.timerWeekRecordDao
        timerStreakDao = dbManager.timerStreakDao
        timerRecordDao = dbManager.timerRecordDao
    }
    
    func records(timerID: UUID) throws -> [TimerRecordDto] {
        try timerRecordDao.findAll(timerID)
    }
    
    func totalRecord(timerId: UUID) throws -> TimerTotalRecordDto? {
        try timerTotalRecordDao.find(timerId: timerId)
    }
    
    func monthRecord(timerId: UUID, date: Date) throws -> TimerMonthRecordDto? {
        let month = Formatter.recordMonthFormatter().string(from: date)
        return try timerMonthRecordDao.find(timerId: timerId, month: month)
    }
    
    func monthReords(timerId: UUID) throws -> [TimerMonthRecordDto] {
        try timerMonthRecordDao.findAll(timerId: timerId)
    }
        
    func weekRecord(timerId: UUID, date: Date) throws -> TimerWeekRecordDto? {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)

        let startOfWeek = calendar.date(from: components)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                
        let strStartOfWeek = Formatter.weekRecordFormatter().string(from: startOfWeek)
        let strEndOfWeek = Formatter.weekRecordFormatter().string(from: endOfWeek)
        
        return try timerWeekRecordDao.find(timerId: timerId, startOfWeek: strStartOfWeek, endOfWeek: strEndOfWeek)
    }
    
    func weekRecords(timerId: UUID) throws -> [TimerWeekRecordDto] {
        try timerWeekRecordDao.findAll(timerId: timerId)
    }
    
    func topStreak(timerId: UUID) throws -> TimerStreakDto? {
        try timerStreakDao.findTopStreak(timerId: timerId)
    }
    
    func streak(timerId: UUID, date: Date) throws -> TimerStreakDto? {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let date = Formatter.recordDateFormatter().string(from: startOfDay)
        return try timerStreakDao.findCurrentStreak(timerId: timerId, date: date)
    }
}
