//
//  TimerRecordReadModel.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




protocol TimerRecordReadModelFacade{
    func records(date: Date) throws -> [TimerRecordDto]
    
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
    
    
    func records(date: Date) throws -> [TimerRecordDto] {
        let date = Formatter.recordDateFormatter().string(from: date)
        return try timerRecordDao.findAll(date)
    }
}
