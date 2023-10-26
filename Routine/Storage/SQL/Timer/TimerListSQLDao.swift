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
    static let tableName = "TIMERLIST"
    private let timerId: Expression<UUID>
    private let timerName: Expression<String>
    private let timerType: Expression<TimerTypeDto>
    private let timerCountdown: Expression<Int?>
    
    init(db: Connection) throws{
        self.db = db
        table = Table(TimerListSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        timerName = Expression<String>("timerName")
        timerType = Expression<TimerTypeDto>("timerType")
        timerCountdown = Expression<Int?>("timerCountdown")
        
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
            table.column(timerType)
            table.column(timerCountdown)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerListSQLDao.tableName)")
    }
    
    
    func save(_ dto: TimerListDto) throws {
        let insert = table.insert(
            timerId <- dto.timerId,
            timerName <- dto.timerName,
            timerType <- dto.timerType,
            timerCountdown <- dto.timerCountdown
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
            timerType <- dto.timerType,
            timerCountdown <- dto.timerCountdown
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
                timerType: $0[timerType],
                timerCountdown: $0[timerCountdown]
            )
        }.first
    }
    
    func findAll() throws -> [TimerListDto] {
        try db.prepareRowIterator(table).map {
            TimerListDto(
                timerId: $0[timerId],
                timerName: $0[timerName],
                timerType: $0[timerType],
                timerCountdown: $0[timerCountdown]
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
