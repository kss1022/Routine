//
//  TimerTotalRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation
import SQLite


final class TimerTotalRecordSQLDao: TimerTotalRecordDao{
    
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "TIMERTOTALRECORD"
    private let timerId: Expression<UUID>
    private let done: Expression<Int>
    private let time: Expression<TimeInterval>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(TimerTotalRecordSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        done = Expression<Int>("done")
        time = Expression<TimeInterval>("time")
        
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
            table.column(done)
            table.column(time)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerTotalRecordSQLDao.tableName)")
    }
    

    
    func find(timerId: UUID) throws -> TimerTotalRecordDto? {
        let query = table.filter(self.timerId == timerId)
            .limit(1)
        
        return try db.pluck(query).map {
            TimerTotalRecordDto(
                timerId: $0[self.timerId],
                done: $0[done],
                time: $0[time]
            )
        }
    }
    
    
    func update(timerId: UUID, time: TimeInterval) throws {
        let query = table.filter(self.timerId == timerId)
            .limit(1)
        
        try db.transaction {
            if try db.pluck(query) == nil{
                try save(timerId: timerId)
            }
            
            try db.run(query.update(done++, self.time += time))
        }
        
        Log.v("Update \(TimerTotalRecordDto.self): \(timerId): +\(time)")
    }
  

    
    private func save(timerId: UUID) throws {
        let insert = table.insert(
            self.timerId <- timerId,
            done <- 0,
            time <- 0
        )
        
        try db.run(insert)
        Log.v("Insert \(TimerTotalRecordDto.self): \(timerId)")
    }
}

