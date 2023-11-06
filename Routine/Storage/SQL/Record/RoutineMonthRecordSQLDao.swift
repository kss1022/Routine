//
//  RoutineMonthRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation
import SQLite



final class RoutineMonthRecordSQLDao: RoutineMonthRecordDao{

    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "ROUTINEMONTHRECORD"
    private let routineId: Expression<UUID>
    private let recordMonth: Expression<String>
    private let done: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineMonthRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        recordMonth = Expression<String>("recordMonth")
        done = Expression<Int>("done")
        
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
            table.column(recordMonth)
            table.column(done)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineMonthRecordSQLDao.tableName)")
    }
    
    func save(_ dto: RoutineMonthRecordDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            recordMonth <- dto.recordMonth,
            done <- dto.done
        )
        
        try db.run(insert)
        Log.v("Insert \(RoutineMonthRecordDto.self): \(dto)")
    }
    
    func find(routineId: UUID, recordMonth: String) throws -> RoutineMonthRecordDto? {
        let query = table.filter(self.routineId == routineId && self.recordMonth == recordMonth)
            .limit(1)
        
        return try db.prepare(query)
            .map {
                RoutineMonthRecordDto(
                    routineId: $0[self.routineId],
                    recordMonth: $0[self.recordMonth],
                    done: $0[done]
                )
            }.first        
    }
    
    
    func updateDone(routineId: UUID, recordMonth: String, increment: Int) throws {
        if try find(routineId: routineId, recordMonth: recordMonth) == nil{
            try save(
                RoutineMonthRecordDto(
                    routineId: routineId,
                    recordMonth: recordMonth,
                    done: 0
                )
            )
        }
        
        let query = table.filter(self.routineId == routineId && self.recordMonth == recordMonth)
            .limit(1)
        try db.run(query.update(self.done += increment))
        Log.v("Update Complete \(RoutineMonthRecordDto.self): \(routineId) \(increment)")
    }
    

    
}
