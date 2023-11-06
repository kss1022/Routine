//
//  TimerRecordReadModel.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




protocol TimerRecordReadModelFacade{
    func record(timerId: UUID, startAt: Date) throws -> TimerRecordDto?
    func records(date: Date) throws -> [TimerRecordDto]
}


public final class TimerRecordReadModelFacadeImp: TimerRecordReadModelFacade{

    private let timerRecordDao: TimerRecordDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
                        
        timerRecordDao = dbManager.timerRecordDao
    }
    
    
    
    func record(timerId: UUID, startAt: Date) throws -> TimerRecordDto? {
        try timerRecordDao.find(timerId: timerId, startAt: startAt)
    }
    
    func records(date: Date) throws -> [TimerRecordDto] {
        let date = Formatter.recordDateFormatter().string(from: date)
        return try timerRecordDao.findAll(date)
    }
}
