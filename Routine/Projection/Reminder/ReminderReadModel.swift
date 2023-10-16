//
//  ReminderReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/16/23.
//

import Foundation



protocol ReminderReadModelFacade{
    func reminder(id: UUID) throws -> ReminderDto?
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
    
}
