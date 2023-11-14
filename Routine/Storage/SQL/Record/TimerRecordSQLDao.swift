//
//  TimerRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation
import SQLite


final class TimerRecordSQLDao: TimerRecordDao{

    
    private let db : Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "TIMERRECORD"
    private let timerId: Expression<UUID>
    private let recordId: Expression<UUID>
    private let recordDate: Expression<String>
    private let startAt: Expression<Date>
    private let endAt: Expression<Date?>
    private let duration: Expression<Double?>
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(TimerRecordSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        recordId = Expression<UUID>("recordId")
        recordDate = Expression<String>("recordDate")
        startAt = Expression<Date>("startAt")
        endAt = Expression<Date?>("endAt")
        duration = Expression<Double?>("duration")
        
        
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
            table.column(recordId, primaryKey: true)
            table.column(recordDate)
            table.column(startAt)
            table.column(endAt)
            table.column(duration)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerRecordSQLDao.tableName)")
    }
    

    
    func save(_ dto: TimerRecordDto) throws {
        let insert = table.insert(
            timerId <- dto.timerId,
            recordId <- dto.recordId,
            recordDate <- dto.recordDate,
            startAt <- dto.startAt,
            endAt <- dto.endAt,
            duration <- dto.duration
        )
        
        try db.run(insert)
        Log.v("Insert \(TimerRecordDto.self): \(dto)")
    }
    
    func updateComplete(recordId: UUID, endAt: Date, duration: Double) throws {
        let query = table.filter(self.recordId == recordId)
            .limit(1)
        
        let update = query.update(
            self.endAt <- endAt,
            self.duration <- duration
        )
        
        try db.run(update)
        Log.v("Update \(TimerRecordDto.self): RecordId-\(recordId) EndAt-\(endAt) Duration-\(duration)")
    }
    
    func find(timerId: UUID, startAt: Date) throws -> TimerRecordDto? {
        let query = table.filter(self.timerId == timerId && self.startAt == startAt)
        
        return try db.prepareRowIterator(query).map {
            TimerRecordDto(
                timerId: $0[self.timerId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                startAt: $0[self.startAt],
                endAt: $0[endAt],
                duration: $0[duration]
            )
        }.first
    }
    
    func findAll(timerId: UUID, date: String) throws -> [TimerRecordDto] {
        let query = table.filter(self.timerId == timerId && recordDate == date)
        
        return try db.prepareRowIterator(query).map {
            TimerRecordDto(
                timerId: $0[self.timerId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                startAt: $0[startAt],
                endAt: $0[endAt],
                duration: $0[duration]
            )
        }
    }
    
    func findAll(_ date: String) throws -> [TimerRecordDto] {
        let query = table.filter( recordDate == date)
        
        return try db.prepareRowIterator(query).map {
            TimerRecordDto(
                timerId: $0[timerId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                startAt: $0[startAt],
                endAt: $0[endAt],
                duration: $0[duration]
            )
        }
    }
    
    func findAll(_ timerId: UUID) throws -> [TimerRecordDto] {
        let query = table.filter( self.timerId == timerId)
        
        return try db.prepareRowIterator(query).map {
            TimerRecordDto(
                timerId: $0[self.timerId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                startAt: $0[startAt],
                endAt: $0[endAt],
                duration: $0[duration]
            )
        }
    }
    }

