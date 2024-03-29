//
//  TimerListDao.swift
//  TimerListSQLDao
//
//  Created by 한현규 on 10/19/23.
//

import Foundation
import SQLite


final class TimerListSQLDao: TimerListDao{

    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    internal static let tableName = "TIMERLIST"
    private let timerId: Expression<UUID>
    private let timerName: Expression<String>
    private let emoji: Expression<String>
    private let tint: Expression<String>
    private let timerType: Expression<TimerTypeDto>
    
    init(db: Connection) throws{
        self.db = db
        table = Table(TimerListSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        timerName = Expression<String>("timerName")
        emoji = Expression<String>("emoji")
        tint = Expression<String>("tint")
        timerType = Expression<TimerTypeDto>("timerType")
        
        try setup()
    }
    
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        try db.run(table.create(ifNotExists: true){ table in
            table.column(timerId, primaryKey: true)
            table.column(timerName)
            table.column(emoji)
            table.column(tint)
            table.column(timerType)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerListSQLDao.tableName)")
    }
    
    
    func save(_ dto: TimerListDto) throws {
        let insert = table.insert(
            timerId <- dto.timerId,
            timerName <- dto.timerName,
            emoji <- dto.emoji,
            tint <- dto.tint,
            timerType <- dto.timerType
        )
        
        
        try db.run(insert)
        Log.v("Insert \(TimerListDto.self): \(dto)")
    }
    
    func update(_ dto: TimerListDto) throws {
        let query = table.filter(timerId == dto.timerId)
            .limit(1)
        
        let update = query.update(
            timerId <- dto.timerId,
            timerName <- dto.timerName,
            emoji <- dto.emoji,
            tint <- dto.tint,
            timerType <- dto.timerType
        )
        
        try db.run(update)
        Log.v("Update \(TimerListDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> TimerListDto? {
        let query = table.filter(timerId == id)
            .limit(1)
        
        return try db.prepare(query).map {
            TimerListDto(
                timerId: $0[timerId],
                timerName: $0[timerName],
                emoji: $0[emoji],
                tint: $0[tint],
                timerType: $0[timerType]
            )
        }.first
    }
    
    func findAll() throws -> [TimerListDto] {
        try db.prepareRowIterator(table).map {
            TimerListDto(
                timerId: $0[timerId],
                timerName: $0[timerName],
                emoji: $0[emoji],
                tint: $0[tint],
                timerType: $0[timerType]
            )
        }
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(timerId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(TimerListDto.self): \(id)")
    }
    
}
