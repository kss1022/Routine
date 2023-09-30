//
//  RoutineReadModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



public final class RoutineReadModelFacade{
    
    private let routineListDao: RoutineListDao
    private let routineDetailDao: RoutineDetailDao
    
    private(set) var emojis = [EmojiDto]()
    private(set) var tints = [TintDto]()
    
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
    
    func fetchEmojis() async throws{
        let path = Bundle.main.path(forResource: "emojis", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let emojis = try JSONDecoder().decode([EmojiDto].self, from: data)
        self.emojis = emojis
    }
    
    func fetchTints() async throws{
        let path = Bundle.main.path(forResource: "tints", ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let tints = try JSONDecoder().decode([TintDto].self, from: data)
        self.tints = tints
    }
}
