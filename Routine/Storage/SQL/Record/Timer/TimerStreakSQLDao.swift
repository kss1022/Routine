//
//  TimerStreakSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation
import SQLite



final class TimerStreakSQLDao: TimerStreakDao{
    
    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "TIMERSTREAK"
    private let timerId: Expression<UUID>
    private let startDate: Expression<String>
    private let endDate: Expression<String>
    private let streakCount: Expression<Int>
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(TimerStreakSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        startDate = Expression<String>("startDate")
        endDate = Expression<String>("endDate")
        streakCount =  Expression<Int>("streakCount")
        
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
            table.column(startDate)
            table.column(endDate)
            table.column(streakCount)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerStreakSQLDao.tableName)")
    }
    
    func find(timerId: UUID, date: String) throws -> TimerStreakDto? {
        let query = table.filter(self.timerId == timerId && self.startDate <= date && self.endDate >= date )
        
        return try db.pluck(query).flatMap {
            TimerStreakDto(
                timerId: $0[self.timerId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
    
    func findTopStreak(timerId: UUID) throws -> TimerStreakDto? {
        let query = table.filter(self.timerId == timerId)
            .order(self.streakCount.desc)
        
        return try db.pluck(query).flatMap {
            TimerStreakDto(
                timerId: $0[self.timerId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
    
    func findCurrentStreak(timerId: UUID, date: String) throws -> TimerStreakDto? {
        let query = table.filter(self.timerId == timerId && self.endDate == date )
        
        return try db.pluck(query).map {
            TimerStreakDto(
                timerId: $0[self.timerId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
        
    func update(timerId: UUID, today: String, yesterday: String) throws{
        try db.transaction {
            let yesturedayQuery = table.filter(self.timerId == timerId && self.endDate == yesterday)
            let todayQuery = table.filter(self.timerId == timerId && self.endDate == today)
            
            if try db.pluck(todayQuery) != nil{
                return
            }
            
            if try db.pluck(yesturedayQuery) == nil{
                try save(timerId: timerId, date: today)
            }            
            let query = table.filter(self.timerId == timerId && endDate == today)
            try db.run(query.update(streakCount++))
            Log.v("Update \(TimerStreakDto.self): \(timerId): \(today)")
        }
    }
    
    
    //MARK: Private
    private func save(timerId: UUID, date: String) throws{
        let insert = table.insert(
            self.timerId <- timerId,
            startDate <- date,
            endDate <- date,
            streakCount <- 0
        )
        try db.run(insert)
        Log.v("Insert \(TimerStreakDto.self): \(timerId) \(date)")
    }
    
}
