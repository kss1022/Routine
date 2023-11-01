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
    
    func timerCountdown(id: UUID) throws -> TimerCountdownDto?
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto]
    
}


public final class TimerReadModelFacadeImp: TimerReadModelFacade{
    
    private let timerListDao: TimerListDao
    private let timerCountdownDao: TimerCountdownDao
    private let timerSectionListDao: TimerSectionListDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else{
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        self.timerListDao = dbManager.timerListDao
        self.timerCountdownDao = dbManager.timerCountdownDao
        self.timerSectionListDao = dbManager.timerSectionListDao        
    }
    
    func timer(id: UUID) throws -> TimerListDto? {
        try timerListDao.find(id)
    }
    
    func timerLists() throws -> [TimerListDto] {
        try timerListDao.findAll()
    }
    
    func timerCountdown(id: UUID) throws -> TimerCountdownDto? {
        try timerCountdownDao.find(id)
    }
    
    func timerSectionLists(id: UUID) throws -> [TimerSectionListDto] {
        try timerSectionListDao.find(id)
    }
    
    
}
