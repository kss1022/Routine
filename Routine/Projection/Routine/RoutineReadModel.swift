//
//  RoutineReadModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation
import Combine


protocol RoutineReadModelFacade{
    func routineLists() throws -> [RoutineListDto]
    func routineDetail(id: UUID) throws -> RoutineDetailDto?
}

public final class RoutineReadModelFacadeImp: RoutineReadModelFacade{
    
    private let routineListDao: RoutineListDao
    private let routineDetailDao: RoutineDetailDao

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        routineListDao = dbManager.routineListDao
        routineDetailDao = dbManager.routineDetailDao
    }
    
    func routineLists() throws -> [RoutineListDto]{
        try routineListDao.findAll()
    }
    
    func routineDetail(id: UUID) throws -> RoutineDetailDto?{
        try routineDetailDao.find(id)
    }
    
 
}
