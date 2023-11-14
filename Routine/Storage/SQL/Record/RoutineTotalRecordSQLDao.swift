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
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineTotalRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        totalDone = Expression<Int>("totalDone")
                
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
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineTotalRecordSQLDao.tableName)")
    }
    
    func save(_ dto: RoutineTotalRecordDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            totalDone <- dto.totalDone
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
                    totalDone: $0[totalDone]
                )
            }.first
    }
    
    
    
    func complete(routineId: UUID) throws {
        if try find(routineId: routineId) == nil{
            try save(
                RoutineTotalRecordDto(
                    routineId: routineId,
                    totalDone: 0
                )
            )
        }
        
        let query = table.filter(self.routineId == routineId)
            .limit(1)
        try db.run(query.update(self.totalDone += 1))
        Log.v("Complete \(RoutineTotalRecordDto.self): \(routineId)")
    }
    
    func cancel(routineId: UUID) throws {
        let query = table.filter(self.routineId == routineId)
            .limit(1)
        try db.run(query.update(self.totalDone -= 1))
        Log.v("Cancel \(RoutineTotalRecordDto.self): \(routineId)")
    }
    
}
    
