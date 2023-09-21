//
//  RoutineReadModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



final class RoutineReadModelFacade{
    
    private let routineListDao: RoutineListDao
    private let routineDetailDao: RoutineDetailDao
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseError.couldNotGetDatabaseManagerInstance
        }
        
        routineListDao = dbManager.routineListDao
        routineDetailDao = dbManager.routineDetailDao
    }
    
    func routineList() throws -> [RoutineListDto]{
        try routineListDao.findAll()
    }
    
    func routineDetail(id: UUID) throws -> RoutineDetailDto?{
        try routineDetailDao.find(id)
    }
    
}
