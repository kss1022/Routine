//
//  RoutineWeekRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import SQLite



final class RoutineWeekRecordSQLDao: RoutineWeekRecordDao{
    
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    internal static let tableName = "ROUTINEWEEKRECORD"
    private let routineId: Expression<UUID>
    private let year: Expression<Int>
    private let weekOfYear: Expression<Int>
    private let sunday: Expression<Bool>
    private let monday: Expression<Bool>
    private let tuesday: Expression<Bool>
    private let wednesday: Expression<Bool>
    private let thursday: Expression<Bool>
    private let friday: Expression<Bool>
    private let saturday: Expression<Bool>
    
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineWeekRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        year = Expression<Int>("year")
        weekOfYear = Expression<Int>("weekOfYear")
        sunday = Expression<Bool>("sunday")
        monday = Expression<Bool>("monday")
        tuesday = Expression<Bool>("tuesday")
        wednesday = Expression<Bool>("wednesday")
        thursday = Expression<Bool>("thursday")
        friday = Expression<Bool>("friday")
        saturday = Expression<Bool>("saturday")
        
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
            table.column(year)
            table.column(weekOfYear)
            table.column(sunday)
            table.column(monday)
            table.column(tuesday)
            table.column(wednesday)
            table.column(thursday)
            table.column(friday)
            table.column(saturday)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineWeekRecordSQLDao.tableName)")
    }
    
    func save(_ dto: RoutineWeekRecordDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            year <- dto.year,
            weekOfYear <- dto.weekOfYear,
            sunday <- dto.sunday,
            monday <- dto.monday,
            tuesday <- dto.tuesday,
            wednesday <- dto.wednesday,
            thursday <- dto.thursday,
            friday <- dto.friday,
            saturday <- dto.saturday
        )
        
        try db.run(insert)
        Log.v("Insert \(RoutineWeekRecordDto.self): \(dto)")
    }
    
    func find(routineId: UUID, year: Int, weekOfYear: Int) throws -> RoutineWeekRecordDto? {
        let query = table.filter(self.routineId == routineId && self.year == year && self.weekOfYear == weekOfYear)
            .limit(1)
        
        return try db.prepare(query).map {
            RoutineWeekRecordDto(
                routineId: $0[self.routineId],
                year: $0[self.year],
                weekOfYear: $0[self.weekOfYear],
                sunday: $0[sunday],
                monday: $0[monday],
                tuesday: $0[tuesday],
                wednesday: $0[wednesday],
                thursday: $0[thursday],
                friday: $0[friday],
                saturday: $0[saturday]
            )
        }.first
    }
    
    func complete(routineId: UUID, year: Int, weekOfYear: Int, dayOfWeek: Int) throws {
        if try find(routineId: routineId, year: year, weekOfYear: weekOfYear) == nil{
            try save(
                RoutineWeekRecordDto(
                    routineId: routineId,
                    year: year,
                    weekOfYear: weekOfYear
                )
            )
        }
        
        let query = table.filter(self.routineId == routineId && self.year == year && self.weekOfYear == weekOfYear)
            .limit(1)
        
        
        switch dayOfWeek{
        case 0: try db.run(query.update(self.sunday <- true))
        case 1: try db.run(query.update(self.monday <- true))
        case 2: try db.run(query.update(self.tuesday <- true))
        case 3: try db.run(query.update(self.wednesday <- true))
        case 4: try db.run(query.update(self.thursday <- true))
        case 5: try db.run(query.update(self.friday <- true))
        case 6: try db.run(query.update(self.saturday <- true))
        default: fatalError("Invalid dayOfWeek: \(dayOfWeek)")
        }
        Log.v("Complete \(RoutineWeekRecordSQLDao.self): \(year)-\(weekOfYear)-\(dayOfWeek)")
    }
    
    func cancel(routineId: UUID, year: Int, weekOfYear: Int, dayOfWeek: Int) throws {
        let query = table.filter(self.routineId == routineId && self.year == year && self.weekOfYear == weekOfYear)
            .limit(1)
        
        
        switch dayOfWeek{
        case 0: try db.run(query.update(self.sunday <- false))
        case 1: try db.run(query.update(self.monday <- false))
        case 2: try db.run(query.update(self.tuesday <- false))
        case 3: try db.run(query.update(self.wednesday <- false))
        case 4: try db.run(query.update(self.thursday <- false))
        case 5: try db.run(query.update(self.friday <- false))
        case 6: try db.run(query.update(self.saturday <- false))
        default: fatalError("Invalid dayOfWeek: \(dayOfWeek)")
        }
        Log.v("Cancel \(RoutineWeekRecordSQLDao.self): \(year)-\(weekOfYear)-\(dayOfWeek)")
    }
    
}
