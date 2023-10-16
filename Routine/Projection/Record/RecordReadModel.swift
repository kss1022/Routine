//
//  RecordReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



protocol RecordReadModelFacade{
    func record(routineId: UUID, date: Date) throws -> RecordDto?
    func records(date: Date) throws -> [RecordDto]
    func records(routineId: UUID) throws -> [RecordDto]
}


public final class RecordReadModelFacadeImp: RecordReadModelFacade{        
    
    private let recordDao: RecordDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        recordDao = dbManager.recordDao
    }
    func record(routineId: UUID, date: Date) throws -> RecordDto? {
        let date =  Formatter.recordFormatter().string(from: date)
        return try recordDao.find(routineId: routineId, date: date)
    }
    
    func records(date: Date) throws -> [RecordDto] {
        let date =  Formatter.recordFormatter().string(from: date)
        return try recordDao.findAll(date)
    }
    
    func records(routineId: UUID) throws -> [RecordDto] {
        return try recordDao.findAll(routineId)
    }
    
}
