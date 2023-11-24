//
//  ProfileReadModel.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation


protocol ProfileReadModelFacade{
    func profile() throws -> ProfileDto?
}

public final class ProfileReadModelFacadeImp : ProfileReadModelFacade{
    
    private let profileDao: ProfileDao
    

    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        profileDao = dbManager.profileDao
    }
    func profile() throws -> ProfileDto? {
        try profileDao.find()
    }
    
}
