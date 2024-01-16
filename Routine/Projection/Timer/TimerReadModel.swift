//
//  TimerReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



protocol TimerReadModelFacade{
    func timer(id: UUID) throws -> TimerListDto?
    func timerLists() throws -> [TimerListDto]
    
    func focusTimer(id: UUID) throws -> FocusTimerDto?
    func tabatTimer(id: UUID) throws -> TabataTimerDto?
    func roundTimer(id: UUID) throws -> RoundTimerDto?
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto]
    
}


public final class TimerReadModelFacadeImp: TimerReadModelFacade{
    
    private let timerListDao: TimerListDao
    private let focusTimerDao: FocusTimerDao
    private let tabatTimerDao: TabataTimerDao
    private let roundTimerDao: RoundTimerDao
    private let timerSectionListDao: TimerSectionListDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else{
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        self.timerListDao = dbManager.timerListDao
        self.focusTimerDao = dbManager.focusTimerDao
        self.tabatTimerDao = dbManager.tabataTimerDao
        self.roundTimerDao = dbManager.roundTimerDao
        self.timerSectionListDao = dbManager.timerSectionListDao
    }
    
    func timer(id: UUID) throws -> TimerListDto? {
        try timerListDao.find(id)
    }
    
    func timerLists() throws -> [TimerListDto] {
        try timerListDao.findAll()
    }
    

    func focusTimer(id: UUID) throws -> FocusTimerDto? {
        try focusTimerDao.find(id)
    }
    
    func tabatTimer(id: UUID) throws -> TabataTimerDto? {
        try tabatTimerDao.find(id)
    }
    
    func roundTimer(id: UUID) throws -> RoundTimerDto? {
        try roundTimerDao.find(id)
    }
    
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto] {
        try timerSectionListDao.find(id)
    }
    
    
}
