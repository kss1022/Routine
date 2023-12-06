//
//  ReminderSQLDao.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import SQLite


final class ReminderSQLDao: ReminderDao{

    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "REMINDER"
    private let routineId: Expression<UUID>
    private let routineName: Expression<String>
    private let emoji: Expression<String>
    private let title: Expression<String>
    private let body: Expression<String>
    private let year: Expression<Int?>
    private let month: Expression<Int?>
    private let day: Expression<Int?>
    private let weekDays: Expression<SET<Int>?>
    private let monthDays: Expression<SET<Int>?>
    private let hour: Expression<Int>
    private let minute: Expression<Int>
    private let `repeat`: Expression<Bool>
    
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(ReminderSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        routineName = Expression<String>("routineName")
        emoji = Expression<String>("emoji")
        title = Expression<String>("title")
        body = Expression<String>("body")
        year = Expression<Int?>("year")
        month = Expression<Int?>("month")
        day = Expression<Int?>("day")
        weekDays = Expression<SET<Int>?>("weekDays")
        monthDays = Expression<SET<Int>?>("monthDays")
        hour = Expression<Int>("hour")
        minute = Expression<Int>("minute")
        `repeat` = Expression<Bool>("repeat`")
        
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
            table.column(routineName)
            table.column(emoji)
            table.column(title)
            table.column(body)
            table.column(year)
            table.column(month)
            table.column(day)
            table.column(weekDays)
            table.column(monthDays)
            table.column(hour)
            table.column(minute)
            table.column(`repeat`)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(ReminderSQLDao.tableName)")
    }
    

    func save(_ dto: ReminderDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            routineName <- dto.routineName,
            emoji <- dto.emoji,
            title <- dto.title,
            body <- dto.body,
            year <- dto.year,
            month <- dto.month,
            day <- dto.day,
            weekDays <- dto.weekDays.flatMap(SET.init),
            monthDays <- dto.monthDays.flatMap(SET.init),
            hour <- dto.hour,
            minute <- dto.minute,
            `repeat` <- dto.repeat
        )
        
        try db.run(insert)
        Log.v("Insert \(ReminderDto.self): \(dto)")
    }
    
    func update(_ dto: ReminderDto) throws {
        let query = table.filter(routineId == dto.routineId)
            .limit(1)
            
        
        try db.run(
            query.update(
                routineName <- dto.routineName,
                emoji <- dto.emoji,
                title <- dto.title,
                body <- dto.body,
                year <- dto.year,
                month <- dto.month,
                day <- dto.day,
                weekDays <- dto.weekDays.flatMap(SET.init),
                monthDays <- dto.monthDays.flatMap(SET.init),
                hour <- dto.hour,
                minute <- dto.minute,
                `repeat` <- dto.repeat
            )
        )
        Log.v("Update \(ReminderDto.self): \(hour) \(minute)")
    }
    
    func find(id: UUID) throws -> ReminderDto? {
        let query = table.filter(routineId == id)
            .limit(1)
        
        return try db.prepare(query)
            .map {
                ReminderDto(
                    routineId: $0[routineId],
                    routineName: $0[routineName],
                    emoji: $0[emoji],
                    title: $0[title],
                    body: $0[body],
                    year: $0[year],
                    month: $0[month],
                    day: $0[day],
                    weekDays: $0[weekDays]?.set,
                    monthDays: $0[monthDays]?.set,
                    hour: $0[hour],
                    minute: $0[minute],
                    repeat: $0[`repeat`]
                )
            }.first
    }
    
    
    func findAll() throws -> [ReminderDto] {
        try db.prepareRowIterator(table)
            .map {
                ReminderDto(
                    routineId: $0[routineId],
                    routineName: $0[routineName],
                    emoji: $0[emoji],
                    title: $0[title],
                    body: $0[body],
                    year: $0[year],
                    month: $0[month],
                    day: $0[day],
                    weekDays: $0[weekDays]?.set,
                    monthDays: $0[monthDays]?.set,
                    hour: $0[hour],
                    minute: $0[minute],
                    repeat: $0[`repeat`]
                )
            }
    }
    
    func delete(id: UUID) throws {
        let query = table.filter(routineId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(ReminderDto.self): \(id)")
    }
}
