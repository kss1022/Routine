//
//  TimerWeekRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation
import SQLite


final class TimerWeekRecordSQLDao: TimerWeekRecordDao{

        
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "TIMERWEEKRECORD"
    private let timerId: Expression<UUID>
    private let startOfWeek: Expression<String>
    private let endOfWeek: Expression<String>
    
    private let sundayDone: Expression<Int>
    private let sundayTime: Expression<TimeInterval>

    private let mondayDone: Expression<Int>
    private let mondayTime: Expression<TimeInterval>
    
    private let tuesdayDone: Expression<Int>
    private let tuesdayTime: Expression<TimeInterval>
    
    private let wednesdayDone: Expression<Int>
    private let wednesdayTime: Expression<TimeInterval>
    
    private let thursdayDone: Expression<Int>
    private let thursdayTime: Expression<TimeInterval>

    private let fridayDone: Expression<Int>
    private let fridayTime: Expression<TimeInterval>

    private let saturdayDone: Expression<Int>
    private let saturdayTime: Expression<TimeInterval>

    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(TimerWeekRecordSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        startOfWeek = Expression<String>("startOfWeek")
        endOfWeek = Expression<String>("endOfWeek")
        
        sundayDone = Expression<Int>("sundayDone")
        sundayTime = Expression<TimeInterval>("sundayTime")
        
        mondayDone = Expression<Int>("mondayDone")
        mondayTime = Expression<TimeInterval>("mondayTime")
        
        tuesdayDone = Expression<Int>("tuesdayDone")
        tuesdayTime = Expression<TimeInterval>("tuesdayTime")
        
        wednesdayDone = Expression<Int>("wednesdayDone")
        wednesdayTime = Expression<TimeInterval>("wednesdayTime")
        
        thursdayDone = Expression<Int>("thursdayDone")
        thursdayTime = Expression<TimeInterval>("thursdayTime")
        
        fridayDone = Expression<Int>("fridayDone")
        fridayTime = Expression<TimeInterval>("fridayTime")
        
        saturdayDone = Expression<Int>("saturdayDone")
        saturdayTime = Expression<TimeInterval>("saturdayTime")
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
            table.column(startOfWeek)
            table.column(endOfWeek)
            table.column(sundayDone)
            table.column(sundayTime)
            table.column(mondayDone)
            table.column(mondayTime)
            table.column(tuesdayDone)
            table.column(tuesdayTime)
            table.column(wednesdayDone)
            table.column(wednesdayTime)
            table.column(thursdayDone)
            table.column(thursdayTime)
            table.column(fridayDone)
            table.column(fridayTime)
            table.column(saturdayDone)
            table.column(saturdayTime)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerWeekRecordSQLDao.tableName)")
    }
    
    
    func find(timerId: UUID, startOfWeek: String, endOfWeek: String) throws -> TimerWeekRecordDto? {
        let query = table.filter(self.timerId == timerId && self.startOfWeek == startOfWeek && self.endOfWeek == endOfWeek)
            .limit(1)
        
        return try db.pluck(query).map {
            TimerWeekRecordDto(
                timerId: $0[self.timerId],
                startOfWeek: $0[self.startOfWeek],
                endOfWeek: $0[self.endOfWeek],
                sundayDone: $0[sundayDone],
                sundayTime: $0[sundayTime],
                mondayDone: $0[mondayDone],
                mondayTime: $0[mondayTime],
                tuesdayDone: $0[tuesdayDone],
                tuesdayTime: $0[tuesdayTime],
                wednesdayDone: $0[wednesdayDone],
                wednesdayTime: $0[wednesdayTime],
                thursdayDone: $0[thursdayDone],
                thursdayTime: $0[thursdayTime],
                fridayDone: $0[fridayDone],
                fridayTime: $0[fridayTime],
                saturdayDone: $0[saturdayDone],
                saturdayTime: $0[saturdayTime]
            )
        }
    }
    
    func findAll(timerId: UUID) throws -> [TimerWeekRecordDto] {
        let query = table.filter(self.timerId == timerId)
        
        return try db.prepareRowIterator(query).map {
            TimerWeekRecordDto(
                timerId: $0[self.timerId],
                startOfWeek: $0[startOfWeek],
                endOfWeek: $0[endOfWeek],
                sundayDone: $0[sundayDone],
                sundayTime: $0[sundayTime],
                mondayDone: $0[mondayDone],
                mondayTime: $0[mondayTime],
                tuesdayDone: $0[tuesdayDone],
                tuesdayTime: $0[tuesdayTime],
                wednesdayDone: $0[wednesdayDone],
                wednesdayTime: $0[wednesdayTime],
                thursdayDone: $0[thursdayDone],
                thursdayTime: $0[thursdayTime],
                fridayDone: $0[fridayDone],
                fridayTime: $0[fridayTime],
                saturdayDone: $0[saturdayDone],
                saturdayTime: $0[saturdayTime]
            )
        }
    }
    
    func update(timerId: UUID, startOfWeek: String, endOfWeek: String, dayOfWeek: Int, time: TimeInterval) throws {
        let query = table.filter(self.timerId == timerId && self.startOfWeek == startOfWeek && self.endOfWeek == endOfWeek)
            .limit(1)
        
        try db.transaction {
            if try db.pluck(query) == nil{
                try save(timerId: timerId, startOfWeek: startOfWeek, endOfWeek: endOfWeek)
            }
                                    
            switch dayOfWeek{
            case 0: try db.run(query.update(sundayDone++, sundayTime += time))
            case 1: try db.run(query.update(mondayDone++, mondayTime += time))
            case 2: try db.run(query.update(tuesdayDone++, tuesdayTime += time))
            case 3: try db.run(query.update(wednesdayDone++, wednesdayTime += time))
            case 4: try db.run(query.update(thursdayDone++, thursdayTime += time))
            case 5: try db.run(query.update(fridayDone++, fridayTime += time))
            case 6: try db.run(query.update(saturdayDone++, saturdayTime += time))
            default : break
            }
        }
        
        Log.v("Update \(TimerWeekRecordDto.self): \(timerId): \(startOfWeek)~\(endOfWeek) at \(dayOfWeek) +\(time)")
    }
    
    
    
    //MARK: Private
    private func save(timerId: UUID, startOfWeek: String, endOfWeek: String) throws {
        let insert = table.insert(
            self.timerId <- timerId,
            self.startOfWeek <- startOfWeek,
            self.endOfWeek <- endOfWeek,
            self.sundayDone <- 0,
            self.sundayTime <- 0,
            self.mondayDone <- 0,
            self.mondayTime <- 0,
            self.tuesdayDone <- 0,
            self.tuesdayTime <- 0,
            self.wednesdayDone <- 0,
            self.wednesdayTime <- 0,
            self.thursdayDone <- 0,
            self.thursdayTime <- 0,
            self.fridayDone <- 0,
            self.fridayTime <- 0,
            self.saturdayDone <- 0,
            self.saturdayTime <- 0
        )
        
        try db.run(insert)
        Log.v("Insert \(TimerWeekRecordDto.self): (\(timerId), \(startOfWeek)~\(endOfWeek)")
    }
    
}
