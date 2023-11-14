//
//  RoutineRecordSQLDao.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation
import SQLite




final class RoutineRecordSQLDao: RoutineRecordDao{
    
    private let db: Connection
    private let table: Table
    
    // MARK: Columns
    private static let tableName = "ROUTINERECORD"
    private let routineId: Expression<UUID>
    private let recordId: Expression<UUID>
    private let recordDate: Expression<String>
    private let isComplete: Expression<Bool>
    private let completedAt: Expression<Date>
    
    
    init(db: Connection) throws{
        self.db = db
        
        table = Table(RoutineRecordSQLDao.tableName)
        routineId = Expression<UUID>("routineId")
        recordId = Expression<UUID>("recordId")
        recordDate = Expression<String>("recordDate")
        isComplete = Expression<Bool>("isComplete")
        completedAt = Expression<Date>("completedAt")
        
        
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
            table.column(recordId, primaryKey: true)
            table.column(recordDate)
            table.column(isComplete)
            table.column(completedAt)
            table.foreignKey(routineId, references: listTable, routineId, delete: .cascade)
        })
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoutineRecordSQLDao.tableName)")
    }
    

    func save(_ dto: RoutineRecordDto) throws {
        let insert = table.insert(
            routineId <- dto.routineId,
            recordId <- dto.recordId,
            recordDate <- dto.recordDate,
            isComplete <- dto.isComplete,
            completedAt <- dto.completedAt
        )
        
        try db.run(insert)
        Log.v("Insert \(RoutineRecordDto.self): \(dto)")

    }
    

    func find(routineId: UUID, date: String) throws -> RoutineRecordDto? {
        let query = table.filter(
            self.routineId == routineId &&
            self.recordDate == date
        )
            .limit(1)
            .order(recordDate.desc)
        
        return try db.prepare(query)
            .map {
                RoutineRecordDto(
                    routineId: $0[self.routineId],
                    recordId: $0[recordId],
                    recordDate: $0[recordDate],
                    isComplete: $0[isComplete],
                    completedAt: $0[completedAt]
                )
            }.first
    }
    
    
    func findAll(_ date: String) throws -> [RoutineRecordDto] {
        let query = table.filter(recordDate == date)
                            
        return try db.prepareRowIterator(query).map {
            RoutineRecordDto(
                routineId: $0[routineId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                isComplete: $0[isComplete],
                completedAt: $0[completedAt]
            )
        }
    }
    
    func findAll(_ routindId: UUID) throws -> [RoutineRecordDto] {
        let query = table.filter(
            self.routineId == routindId &&
            self.isComplete == true
        )
            .order(recordDate.desc)
                            
        return try db.prepareRowIterator(query).map {
            RoutineRecordDto(
                routineId: $0[routineId],
                recordId: $0[recordId],
                recordDate: $0[recordDate],
                isComplete: $0[isComplete],
                completedAt: $0[completedAt]
            )
        }
    }

    
    func complete(recordId: UUID, completeAt: Date) throws {
        let query = table.filter(self.recordId == recordId)
            .limit(1)
        
        let update = query.update(
            self.isComplete <- true,
            self.completedAt <- completeAt
        )
        
        try db.run(update)
            
        Log.v("Complete \(RoutineRecordDto.self): \(recordId)")
    }
    
    func cancel(recordId: UUID, completeAt: Date) throws {
        let query = table.filter(self.recordId == recordId)
            .limit(1)
        
        let update = query.update(
            self.isComplete <- false,
            self.completedAt <- completeAt
        )
        
        try db.run(update)
            
        Log.v("Cancel \(RoutineRecordDto.self): \(recordId)")
    }
    
}

