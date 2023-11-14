//
//  ReminderSQLDao.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import SQLite


final class ReminderSQLDao: ReminderDao{

    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "REMINDER"
    private let routineId: Expression<UUID>
    private let identifires: Expression<String>
    private let hour: Expression<Int>
    private let minute: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(ReminderSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        identifires = Expression<String>("identifires")
        hour = Expression<Int>("hour")
        minute = Expression<Int>("minute")
        
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
            table.column(identifires)
            table.column(hour)
            table.column(minute)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(ReminderSQLDao.tableName)")
    }
    

    func save(_ dto: ReminderDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            identifires <- dto.identifires,
            hour <- dto.hour,
            minute <- dto.minute
        )
        
        try db.run(insert)
        Log.v("Insert \(ReminderDto.self): \(dto)")
    }
    
    func update(_ dto: ReminderDto) throws {
        let query = table.filter(routineId == dto.routineId)
            .limit(1)
            
        
        try db.run(
            query.update(
                identifires <- dto.identifires,
                hour <- dto.hour,
                minute <- dto.minute
            )
        )
        Log.v("Update \(ReminderDto.self): \(hour) \(minute)")
    }
    
    func find(id: UUID) throws -> ReminderDto? {
        let query = table.filter(routineId == id)
            .limit(1)
        
        return try db.prepare(query)
            .map {
                ReminderDto(
                    routineId: $0[routineId],
                    identifiers: $0[identifires],
                    hour: $0[hour],
                    minute: $0[minute]
                )
            }.first
    }
    
    func delete(id: UUID) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(ReminderDto.self): \(id)")
    }
}
