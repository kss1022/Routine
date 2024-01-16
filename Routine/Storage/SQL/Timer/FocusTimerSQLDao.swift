//
//  FocusTimerSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import SQLite

final class FocusTimerSQLDao: FocusTimerDao{

    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    internal static let tableName = "FOCUSTIMER"
    private let timerId: Expression<UUID>
    private let name: Expression<String>
    private let emoji: Expression<String>
    private let tint: Expression<String>
    private let minutes: Expression<Int>
    
    init(db: Connection) throws{
        self.db = db
        table = Table(FocusTimerSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        name = Expression<String>("name")
        tint = Expression<String>("tint")
        emoji = Expression<String>("emoji")
        minutes = Expression<Int>("minutes")
        try setup()
    }
    
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        let listTable = Table(TimerListSQLDao.tableName)
        
        try db.run(table.create(ifNotExists: true){ table in
            table.column(timerId)
            table.column(name)
            table.column(emoji)
            table.column(tint)
            table.column(minutes)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(FocusTimerSQLDao.tableName)")
    }
    
    
    func save(_ dto: FocusTimerDto) throws {
        let insert = table.insert(
            timerId <- dto.id,
            name <- dto.name,
            emoji <- dto.emoji,
            tint <- dto.tint,
            minutes <- dto.minutes
        )
        
        
        try db.run(insert)
        Log.v("Insert \(FocusTimerDto.self): \(dto)")
    }
    
    func update(_ dto: FocusTimerDto) throws {
        let query = table.filter(timerId == dto.id)
            .limit(1)
        
        let update = query.update(
            timerId <- dto.id,
            name <- dto.name,
            emoji <- dto.emoji,
            tint <- dto.tint,
            minutes <- dto.minutes
        )
        
        try db.run(update)
        Log.v("Update \(FocusTimerDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> FocusTimerDto? {
        let query = table.filter(timerId == id)
            .limit(1)
        
        return try db.prepare(query).map {
            FocusTimerDto(
                id: $0[timerId],
                name: $0[name],
                emoji: $0[emoji],
                tint: $0[tint],
                minutes: $0[minutes]
            )
        }.first
    }

    
    func delete(_ id: UUID) throws {
        let query = table.filter(timerId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(FocusTimerDto.self): \(id)")
    }
    
}
