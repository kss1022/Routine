//
//  RoutineListSQLDao.swift
//  Routine
//
//  Created by 한현규 on 2023/09/20.
//

import Foundation
import SQLite


final class RoutineListSQLDao: RoutineListDao{
    
    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "ROUTINELIST"
    private let routineId: Expression<UUID>
    private let routineName: Expression<String>
    public let routineDescription: Expression<String>
    private let repeatType: Expression<RepeatTypeDto>
    private let repeatValue: Expression<RepeatValueDto>
    public let emojiIcon: Expression<String>
    public let tint: Expression<String>
    private let sequence: Expression<Int64>
    
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineListSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        routineName = Expression<String>("routineName")
        routineDescription = Expression<String>("routineDescription")
        repeatType = Expression<RepeatTypeDto>("repeatType")
        repeatValue = Expression<RepeatValueDto>("repeatValue")
        emojiIcon = Expression<String>("emojiIcon")
        tint = Expression<String>("tint")
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
            table.column(routineDescription)
            table.column(repeatType)
            table.column(repeatValue)
            table.column(emojiIcon)
            table.column(tint)
            table.column(sequence)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineListSQLDao.tableName)")
    }
    
    
    
    func save(_ dto: RoutineListDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            routineName <- dto.routineName,
            routineDescription <- dto.routineDescription,
            repeatType <- dto.repeatType,
            repeatValue <- dto.repeatValue,
            emojiIcon <- dto.emojiIcon,
            tint <- dto.tint,
            sequence <- dto.sequence
        )
        try db.run(insert)
        Log.v("Insert \(RoutineListDto.self): \(dto)")
    }
    
    func update(_ dto: RoutineListDto) throws{
        let query = table.filter(routineId == dto.routineId)
            .limit(1)
        
        let update = query.update(            
            routineName <- dto.routineName,
            routineDescription <- dto.routineDescription,
            repeatType <- dto.repeatType,
            repeatValue <- dto.repeatValue,
            emojiIcon <- dto.emojiIcon,
            tint <- dto.tint,
            sequence <- dto.sequence
        )
        
        try db.run(update)
        Log.v("Update \(RoutineListDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> RoutineListDto? {
        let query = table.filter(routineId == id)
                            .limit(1)
    
        return try db.prepare(query).map {
            RoutineListDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                routineDescription: $0[routineDescription],
                repeatType: $0[repeatType],
                repeatValue: $0[repeatValue],
                emojiIcon: $0[emojiIcon],
                tint: $0[tint],
                sequence: $0[sequence]
            )
        }.first
    }
    
    func findAll() throws -> [RoutineListDto] {
        try db.prepareRowIterator(table).map {
            RoutineListDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                routineDescription: $0[routineDescription],
                repeatType: $0[repeatType],
                repeatValue: $0[repeatValue],
                emojiIcon: $0[emojiIcon],
                tint: $0[tint],
                sequence: $0[sequence]
            )
        }
    }

    
    func updateName(_ id: UUID, name: String) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.update(routineName <- name))
        Log.v("Update \(RoutineListDto.self): \(id) \(name)")
    }
    
    
    func delete(_ id: UUID) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(RoutineListDto.self): \(id)")
    }
    
}

