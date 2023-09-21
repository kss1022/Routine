//
//  RoutineListSQLDao.swift
//  Routine
//
//  Created by 한현규 on 2023/09/20.
//

import Foundation
import SQLite


class RoutineListSQLDao: RoutineListDao{
    
    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "ROUTINELIST"
    private let routineId: Expression<UUID>
    private let routineName: Expression<String>
    private let sequence: Expression<Int64>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineListSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        routineName = Expression<String>("routineName")
        sequence = Expression<Int64>("sequence")
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        try db.run(table.create(ifNotExists: true){ table in
            table.column(routineId, primaryKey: true)
            table.column(routineName)
            table.column(sequence)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineListSQLDao.tableName))")
    }
    
    
    
    func save(_ dto: RoutineListDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            routineName <- dto.routineName,
            sequence <- dto.sequence
        )
        try db.run(insert)
        Log.v("Insert RoutineListDto: \(dto)")
    }
    
    func update(_ dto: RoutineListDto) throws{
        let query = table.filter(routineId == dto.routineId)
            .limit(1)
        
        try db.run(query.update(routineName <- dto.routineName, sequence <- dto.sequence))
        Log.v("Insert RoutineListDto: \(dto)")
    }
    
    func find(_ id: UUID) throws -> RoutineListDto? {
        let query = table.filter(routineId == id)
                            .limit(1)
    
        return try db.prepare(query).map {
            RoutineListDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                sequence: $0[sequence]
            )
        }.first
    }
    
    func findAll() throws -> [RoutineListDto] {
        try db.prepareRowIterator(table).map {
            RoutineListDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                sequence: $0[sequence]
            )
        }
    }

    
    func updateName(_ id: UUID, name: String) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.update(routineName <- name))
        Log.v("Update RoutineListDto: \(id) \(name)")
    }
    
}

