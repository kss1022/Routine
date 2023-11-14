//
//  RoutineStreakSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation
import SQLite



final class RoutineStreakSQLDao: RoutineStreakDao{
                
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "ROUTINESTREAK"
    private let routineId: Expression<UUID>
    private let startDate: Expression<Date>
    private let endDate: Expression<Date>
    private let streakCount: Expression<Int>
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineStreakSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        startDate = Expression<Date>("startDate")
        endDate = Expression<Date>("endDate")
        streakCount =  Expression<Int>("streakCount")
        
        try setup()
    }
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        let listTable = Table(RoutineListSQLDao.tableName)

        
        try db.run(table.create(ifNotExists: true){ table in
            table.column(routineId)
            table.column(startDate)
            table.column(endDate)
            table.column(streakCount)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineStreakSQLDao.tableName)")
    }
    

    
    func save(_ dto: RoutineStreakDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            startDate <- dto.startDate,
            endDate <- dto.endDate,
            streakCount <- dto.streakCount
        )
        try db.run(insert)
        Log.v("Insert \(RoutineStreakDto.self): \(dto)")
    }
    
    func topStreak(routineId: UUID) throws -> RoutineStreakDto? {
        let query = table.filter(self.routineId == routineId)
            .order(self.streakCount.desc)
        
        return try db.pluck(query).flatMap {
            RoutineStreakDto(
                routineId: $0[self.routineId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
    
    func currentStreak(routineId: UUID, date: Date) throws -> RoutineStreakDto? {
        let query = table.filter(self.routineId == routineId && self.endDate == date )
        
        return try db.pluck(query).flatMap {
            RoutineStreakDto(
                routineId: $0[self.routineId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
    
    func find(routineId: UUID, date: Date) throws -> RoutineStreakDto? {
        let query = table.filter(self.routineId == routineId && self.startDate <= date && self.endDate >= date )
        
        return try db.pluck(query).flatMap {
            RoutineStreakDto(
                routineId: $0[self.routineId],
                startDate: $0[startDate],
                endDate: $0[endDate],
                streakCount: $0[streakCount]
            )
        }
    }
    
    
    
    func complete(routineId: UUID, date: Date) throws{
        let yesterday = date.addingTimeInterval(-60 * 60 * 24)
        let tomorrow = date.addingTimeInterval(60 * 60 * 24)
        
        let before = try find(routineId: routineId, date: yesterday)
        let after = try find(routineId: routineId, date: tomorrow)
        
        
        
        if before != nil && after != nil{
            //middel of Streak
            let start = before!.startDate
            let end = after!.endDate
            
            let dto = RoutineStreakDto(
                routineId: routineId,
                startDate: start,
                endDate: end,
                streakCount: before!.streakCount + after!.streakCount + 1
            )
            
            try db.transaction {
                try delete(routineId: routineId, date: yesterday)
                try delete(routineId: routineId, date: tomorrow)
                try save(dto)
            }            
            
            Log.v("Update Complete \(RoutineStreakSQLDao.self) at Middle: \(routineId) \(before!.startDate) ~ \(after!.endDate)")
        }else if before != nil{
            //end of Streak
            let query = table.filter(
                self.routineId == routineId &&
                self.endDate == yesterday
            ).limit(1)
            
            let update = query.update([endDate <- date, streakCount <- before!.streakCount + 1])
            try db.run(update)
            Log.v("Update Complete \(RoutineStreakSQLDao.self) at End: \(routineId) \(before!.startDate) ~ \(date)")
        }else if after != nil{
            //start of Steak
            let query = table.filter(
                self.routineId == routineId &&
                self.startDate == tomorrow
            ).limit(1)
            
            let update = query.update([startDate <- date, streakCount <- after!.streakCount + 1])
            try db.run(update)
            Log.v("Update Complete \(RoutineStreakSQLDao.self) start: \(routineId) \(date) ~ \(after!.endDate) ")
        }else{
            //new Streak
            let dto = RoutineStreakDto(
                routineId: routineId,
                startDate: date,
                endDate: date,
                streakCount: 1
            )
            try save(dto)
            Log.v("Update Complete \(RoutineStreakSQLDao.self) newStreak: \(routineId) \(date)")
        }
                
    }
    
    func cancel(routineId: UUID, date: Date) throws{
        guard let find = try find(routineId: routineId, date: date) else {
            Log.e("UnComplete Fail Sterak is not Exist: \(routineId)  (\(date))")
            return
        }
                
        let query = table.filter(
            self.routineId == routineId &&
            self.startDate < date &&
            self.endDate > date
        ).limit(1)

        
        if find.streakCount == 1{
            //single Streak
            try db.run(query.delete())
            Log.v("Cancel \(RoutineStreakSQLDao.self): \(routineId) \(date)")
        }else if find.startDate == date{
            //start of Streak
            let tomorrow = date.addingTimeInterval( 24 * 60 * 60)
            let update = query.update([startDate <- tomorrow, streakCount -= 1])
            try db.run(update)
            Log.v("Cancel \(RoutineStreakSQLDao.self): \(routineId) \(tomorrow) ~ \(find.endDate)")
        }else if find.endDate == date{
            //end of Streak
            let yesterDay = date.addingTimeInterval(-24 * 60 * 60)
            let update = query.update([endDate <- yesterDay, streakCount -= 1])
            try db.run(update)
            Log.v("Cancel \(RoutineStreakSQLDao.self): \(routineId) \(find.startDate) ~ \(yesterDay)")
        }else{
            //middel of Streak
            
            let yesterday = date.addingTimeInterval(-24 * 60 * 60)
            let tomorrow = date.addingTimeInterval(24 * 60 * 60)
            
            let timeInterval = find.startDate.timeIntervalSince(yesterday)
            let fontStrekCount = Int(timeInterval / (24 * 60 * 60)) + 1
            
            try db.transaction {
                try db.run(query.delete())
                try save(
                    RoutineStreakDto(
                        routineId: routineId,
                        startDate: find.startDate,
                        endDate: yesterday,
                        streakCount: fontStrekCount
                    )
                )
                try save(
                    RoutineStreakDto(
                        routineId: routineId,
                        startDate: tomorrow,
                        endDate: find.endDate,
                        streakCount: find.streakCount - fontStrekCount - 1
                    )
                )
            }
            Log.v("Cancel \(RoutineStreakSQLDao.self): \(routineId) \(find.startDate) ~ \(yesterday) | \(tomorrow) ~ \(find.endDate)")
        }
    }

    
    func delete(routineId: UUID, date: Date) throws {
        let query = table.filter(self.routineId == routineId && self.startDate <= date && self.endDate >= date )
            .limit(1)
        try db.run(query.delete())
        Log.v("Delete \(RoutineStreakSQLDao.self): \(routineId) \(date)")
    }

    
}
