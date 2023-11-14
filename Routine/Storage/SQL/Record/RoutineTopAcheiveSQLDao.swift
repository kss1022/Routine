//
//  RoutineTopAcheiveSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation
import SQLite


final class RoutineTopAcheiveSQLDao: RoutineTopAcheiveDao{
    
    private let db: Connection
    private let table: Table
    
    private let routineId: Expression<UUID>
    private let routineName: Expression<String>
    private let emojiIcon: Expression<String>
    private let tint: Expression<String>
        
    private let totalDone: Expression<Int?>
    private let bestStreak: Expression<Int?>
    
    
    
    init(db: Connection){
        self.db = db
        let routineListTable = Table(RoutineListSQLDao.tableName)
        let routineTotalRecordTable = Table(RoutineTotalRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        routineName = Expression<String>("routineName")
        emojiIcon = Expression<String>("emojiIcon")
        tint = Expression<String>("tint")
        totalDone = Expression<Int?>("totalDone")
        bestStreak = Expression<Int?>("bestStreak")
        
        self.table = routineListTable
            .select([
                routineListTable[routineId],
                routineListTable[routineName],
                routineListTable[emojiIcon],
                routineListTable[tint],
                routineTotalRecordTable[totalDone],
                routineTotalRecordTable[bestStreak],
            ])
            .join(.leftOuter, routineTotalRecordTable, on: routineListTable[routineId] == routineTotalRecordTable[routineId])
    }
    
    
    func find() throws -> [RoutineTopAcheiveDto] {
        let query = self.table.order(totalDone.desc)
        
        return try db.prepare(query).map {
            RoutineTopAcheiveDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                emojiIcon: $0[emojiIcon],
                tint: $0[tint],
                totalDone: $0[totalDone] ?? 0,
                bestStreak: $0[bestStreak] ?? 0
            )
        }
    }
    
}
