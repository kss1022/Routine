//
//  TimerCountdownSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation
import SQLite


final class TimerCountdownSQLDao: TimerCountdownDao{
    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    private static let tableName = "TIMERCOUNTDOWN"
    private let timerId: Expression<UUID>
    private let minute: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        table = Table(TimerCountdownSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        minute = Expression<Int>("minute")
        
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
            table.column(minute)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerCountdownSQLDao.tableName)")
    }
    
    func save(_ dto: TimerCountdownDto) throws {
        let insert = table.insert(
            timerId <- dto.timerId,
            minute <- dto.minute
        )
        
        try db.run(insert)
        Log.v("Insert \(TimerCountdownDto.self): \(dto)")
    }
    
    func update(_ dto: TimerCountdownDto) throws {
        let query = table.filter(timerId == dto.timerId)
            .limit(1)
        
        let update = query.update(
            timerId <- dto.timerId,
            minute <- dto.minute
        )
        
        try db.run(update)
        
        Log.v("Update \(TimerCountdownDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> TimerCountdownDto? {
        let query = table.filter(timerId == id)
            .limit(1)

        return try db.prepare(query).map {
            TimerCountdownDto(
                timerId: $0[timerId],
                minute: $0[minute]
            )
        }.first
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(timerId == id)
            .limit(1)
        
        try db.run(query.delete())
        
        Log.v("Delete \(TimerCountdownDto.self): \(id)")
    }
    
    
}
