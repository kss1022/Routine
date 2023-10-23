//
//  TimerReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



protocol TimerReadModelFacade{
    func timerLists() throws -> [TimerListDto]
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto]
}


public final class TimerReadModelFacadeImp: TimerReadModelFacade{
    
    private let timerListDao: TimerListDao
    private let timerSectionListDao: TimerSectionListDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else{
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        self.timerListDao = dbManager.timerListDao
        self.timerSectionListDao = dbManager.timerSectionListDao
    }
    
    func timerLists() throws -> [TimerListDto] {
        try timerListDao.findAll()
    }
    
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto] {
        try timerSectionListDao.find(id)
    }
    
    
}
