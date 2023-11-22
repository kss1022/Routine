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
    private let startOfWeek: Expression<String>
    private let endOfWeek: Expression<String>
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
        startOfWeek = Expression<String>("startOfWeek")
        endOfWeek = Expression<String>("endOfWeek")
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
            table.column(startOfWeek)
            table.column(endOfWeek)
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
            startOfWeek <- dto.startOfWeek,
            endOfWeek <- dto.endOfWeek,
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
    
    func find(routineId: UUID, startOfWeek: String, endOfWeek: String) throws -> RoutineWeekRecordDto? {
        let query = table.filter(self.routineId == routineId && self.startOfWeek == startOfWeek && self.endOfWeek == endOfWeek)
            .limit(1)
        
        return try db.prepare(query).map {
            RoutineWeekRecordDto(
                routineId: $0[self.routineId],
                startOfWeek: $0[self.startOfWeek],
                endOfWeek: $0[self.endOfWeek],
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
    
    
    func findAll() throws -> [RoutineWeekRecordDto]{        
        try db.prepare(table).map {
            RoutineWeekRecordDto(
                routineId: $0[self.routineId],
                startOfWeek: $0[startOfWeek],
                endOfWeek: $0[endOfWeek],
                sunday: $0[sunday],
                monday: $0[monday],
                tuesday: $0[tuesday],
                wednesday: $0[wednesday],
                thursday: $0[thursday],
                friday: $0[friday],
                saturday: $0[saturday]
            )
        }
    }
    
    
    func complete(dto: RoutineWeekRecordDto, dayOfWeek: Int) throws {
        
           
        if try find(routineId: dto.routineId, startOfWeek: dto.startOfWeek, endOfWeek: dto.endOfWeek) == nil{
            try save(RoutineWeekRecordDto(
                routineId: dto.routineId,
                startOfWeek: dto.startOfWeek,
                endOfWeek: dto.endOfWeek
            ))
        }        
        
        let query = table.filter(
            self.routineId == dto.routineId &&
            self.startOfWeek == dto.startOfWeek &&
            self.endOfWeek == dto.endOfWeek
        )
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
        Log.v("Complete \(RoutineWeekRecordSQLDao.self): \(startOfWeek)~\(endOfWeek): \(dayOfWeek)")
    }
    
    func cancel(dto: RoutineWeekRecordDto, dayOfWeek: Int) throws {
        
        let query = table.filter(
            self.routineId == dto.routineId &&
            self.startOfWeek == dto.startOfWeek &&
            self.endOfWeek == dto.endOfWeek
        )
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
        Log.v("Complete \(RoutineWeekRecordSQLDao.self): \(startOfWeek)~\(endOfWeek): \(dayOfWeek)")
    }

}
