//
//  RepeatSQLDao.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation
import SQLite


    
final class RepeatSQLDao: RepeatDao{
        
    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    private static let tableName = "REPEAT"
    private let routineId: Expression<UUID>
    private let repeatType: Expression<RepeatTypeDto>
    private let repeatValue: Expression<RepeatValueDto>
    
    init(db: Connection) throws{
        self.db = db
        table = Table(RepeatSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        repeatType = Expression<RepeatTypeDto>("repeatType")
        repeatValue = Expression<RepeatValueDto>("repeatValue")
        
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
            table.column(repeatType)
            table.column(repeatValue)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade) // update: .cascade, ,
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RepeatSQLDao.tableName)")
    }
    
    
    
    func save(_ dto: RepeatDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            repeatType <- dto.repeatType,
            repeatValue <- dto.repeatValue
        )
        try db.run(insert)
        Log.v("Insert \(RepeatDao.self): \(dto)")
    }
    
    func update(_ dto: RepeatDto) throws {
        let query = table.filter(routineId == dto.routineId)
            .limit(1)
        
        let update = query.update(
            routineId <- dto.routineId,
            repeatType <- dto.repeatType,
            repeatValue <- dto.repeatValue
        )
        
        try db.run(update)
        Log.v("Update \(RepeatDao.self): \(dto)")
    }
    
    
    
    func find(_ routinId: UUID) throws -> RepeatDto? {
        let query = table.filter(routineId == routinId)
            .limit(1)
    
        return try db.prepare(query).map {
            RepeatDto(
                routineId: $0[routineId],
                repeatType: $0[repeatType],
                repeatValue: $0[repeatValue]
            )
        }.first
    }
    
    func findAll() throws -> [RepeatDto] {
        try db.prepareRowIterator(table).map {
            RepeatDto(
                routineId: $0[routineId],
                repeatType: $0[repeatType],
                repeatValue: $0[repeatValue]
            )
        }
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(RepeatDao.self): \(id)")
    }
    
    
}
