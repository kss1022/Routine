//
//  RoutineTotalRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation
import SQLite



final class RoutineTotalRecordSQLDao: RoutineTotalRecordDao{

        
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "ROUTINETOTALRECORD"
    private let routineId: Expression<UUID>
    private let totalDone: Expression<Int>
    private let bestStreak: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineTotalRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        totalDone = Expression<Int>("totalDone")
        bestStreak = Expression<Int>("bestStreak")
                
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        let listTable = Table(RoutineListSQLDao.tableName)
        
        
        try db.run(table.create(ifNotExists: true){ table in
            table.column(routineId)
            table.column(totalDone)
            table.column(bestStreak)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineTotalRecordSQLDao.tableName)")
    }
    
    func save(_ dto: RoutineTotalRecordDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            totalDone <- dto.totalDone,
            bestStreak <- dto.totalDone
        )
        
        try db.run(insert)
        Log.v("Insert \(RoutineTotalRecordDto.self): \(dto)")
    }
    
    func find(routineId: UUID) throws -> RoutineTotalRecordDto? {
        let query = table.filter(self.routineId == routineId)
            .limit(1)
        
        return try db.prepare(query)
            .map {
                RoutineTotalRecordDto(
                    routineId: $0[self.routineId],
                    totalDone: $0[totalDone],
                    bestStreak: $0[bestStreak]
                )
            }.first
    }
    
    
    
    func updateTotalDone(routineId: UUID, increment: Int) throws {
        let query = table.filter(self.routineId == routineId)
            .limit(1)
        try db.run(query.update(self.totalDone += increment))
        Log.v("Update Complete \(RoutineTotalRecordDto.self): \(routineId) \(increment)")
    }
    
    
    
}
    
