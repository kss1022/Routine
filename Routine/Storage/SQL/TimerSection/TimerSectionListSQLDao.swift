//
//  TimerSectionListDto+SQL.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation
import SQLite


final class TimerSectionListSQLDao: TimerSectionListDao{
    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    private static let tableName = "TIMERSERSECTIONLIST"
    private let timerId: Expression<UUID>
    private let sectionName: Expression<String>
    private let sectionDescription: Expression<String>
    private let timerSectionType: Expression<TimerSectionTypeDto>
    private let timerSectionValue: Expression<TimerSectionValueDto>
    private let sequecne: Expression<Int>
    private let emoji: Expression<String>
    private let tint: Expression<String>
    
    init(db: Connection) throws{
        self.db = db
        table = Table(TimerSectionListSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        sectionName = Expression<String>("sectionName")
        sectionDescription = Expression<String>("sectionDescription")
        timerSectionType = Expression<TimerSectionTypeDto>("TimerSectionType")
        timerSectionValue = Expression<TimerSectionValueDto>("timerSectionValue")
        sequecne = Expression<Int>("sequecne")
        emoji = Expression<String>("emoji")
        tint = Expression<String>("tint")
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
            table.column(sectionName)
            table.column(sectionDescription)
            table.column(timerSectionType)
            table.column(timerSectionValue)
            table.column(sequecne)
            table.column(emoji)
            table.column(tint)
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TimerSectionListSQLDao.tableName)")
    }
    
    
    func save(_ dtos: [TimerSectionListDto]) throws {
        try db.transaction {
            let many = dtos.map {
                [
                    timerId <- $0.timerId,
                    sectionName <- $0.sectionName,
                    sectionDescription <- $0.sectionDescription,
                    timerSectionType <- $0.timerSectionType,
                    timerSectionValue <- $0.timerSectionValue,
                    sequecne <- $0.sequence,
                    emoji <- $0.emoji,
                    tint <- $0.tint
                ]
            }
            
            try many.forEach {
                let insert = table.insert($0)
                try db.run(insert)
            }
        }
        
        Log.v("Insert \(TimerSectionListDto.self): \(dtos.map { $0.sectionName }.joined(separator: ", "))")
    }
    
    func update(_ dto: [TimerSectionListDto]) throws {
        //TODO: UPDate List
    }
    
    func find(_ id: UUID) throws -> [TimerSectionListDto] {
        let query = table.filter(timerId == id)            
            .order(sequecne.asc)
        
        return try db.prepareRowIterator(query).map {
        
            TimerSectionListDto(
                timerId: $0[timerId],
                sectionName: $0[sectionName],
                sectionDescription: $0[sectionDescription],
                timerSectionType: $0[timerSectionType],
                timerSectionValue: $0[timerSectionValue],
                sequence: $0[sequecne],
                emoji: $0[emoji],
                tint: $0[tint]
            )
        }
    }
    
    func delete(_ id: UUID) throws {
        let query = table.filter(timerId == id)
                    
        try db.run(query.delete())
        Log.v("Delete \(TimerSectionListDto.self): \(id)")
    }
    
    
}
