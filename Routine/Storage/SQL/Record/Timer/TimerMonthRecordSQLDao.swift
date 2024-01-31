//
//  TimerMonthRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation
import SQLite



final class TimerMonthRecordSQLDao: TimerMonthRecordDao{
    
    
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "TIMERMONTHRECORD"
    private let timerId: Expression<UUID>
    private let month: Expression<String>
    private let time: Expression<TimeInterval>
    private let done: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(TimerMonthRecordSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        month = Expression<String>("month")
        time = Expression<TimeInterval>("time")
        done = Expression<Int>("done")
        
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
            table.column(month)
            table.column(done)
            table.column(time)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerMonthRecordSQLDao.tableName)")
    }
         
    
    func update(timerId: UUID, month: String, time: TimeInterval) throws{
        let query = table.filter(self.timerId == timerId && self.month == month)
            .limit(1)
        
        try db.transaction {
            if try db.pluck(query) == nil{
                try save(timerId: timerId, month: month)
            }
            
            try db.run(query.update(done += 1))
            try db.run(query.update(self.time += time))
        }
        
        Log.v("Update \(TimerMonthRecordDto.self): \(timerId): \(month) +\(time)")
    }
    
    func find(timerId: UUID, month: String) throws -> TimerMonthRecordDto?{
        let query = table.filter(self.timerId == timerId && self.month == month)
            .limit(1)

        return try db.pluck(query)
            .map {
                TimerMonthRecordDto(
                    timerId: $0[self.timerId],
                    month: $0[self.month],
                    done: $0[done],
                    time: $0[time]
                )
            }
    }
    
    func findAll(timerId: UUID) throws -> [TimerMonthRecordDto] {
        let query = table.filter(self.timerId == timerId)
        
        return try db.prepareRowIterator(query).map {
            TimerMonthRecordDto(
                timerId: $0[self.timerId],
                month: $0[month],
                done: $0[done],
                time: $0[time]
            )
        }
    }
    
    //MARK: Private
    private func save(timerId: UUID, month: String) throws {
        let insert = table.insert(
            self.timerId <- timerId,
            self.month <- month,
            done <- 0,
            self.time <- 0
        )
        
        try db.run(insert)
        Log.v("Insert \(TimerMonthRecordDto.self): (\(timerId), \(month)")
    }
}



