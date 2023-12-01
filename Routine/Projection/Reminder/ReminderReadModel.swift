//
//  ReminderReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/16/23.
//

import Foundation



protocol ReminderReadModelFacade{
    func reminder(id: UUID) throws -> ReminderDto?
    func reminders() throws -> [ReminderDto]
}


public final class ReminderReadModelFacadeImp: ReminderReadModelFacade{
    
    private let reminderDao: ReminderDao
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        reminderDao = dbManager.reminderDao
    }
    
    func reminder(id: UUID) throws -> ReminderDto? {
        try reminderDao.find(id: id)
    }
    
    func reminders() throws -> [ReminderDto] {
        try reminderDao.findAll()
    }
    
}
