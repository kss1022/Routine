//
//  RepeatReadModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


protocol RepeatReadModelFacade{
    func repeatList() throws -> [RepeatDto]
}

public final class RepeatReadModelFacadeImp: RepeatReadModelFacade{
    
    private let repeatDao: RepeatDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        repeatDao = dbManager.repeatDao
    }
    
    func repeatList() throws -> [RepeatDto] {
        try repeatDao.findAll()
    }
    
 
}
