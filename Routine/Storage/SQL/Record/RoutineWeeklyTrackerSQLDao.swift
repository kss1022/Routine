//
//  RoutineWeeklyTrackerSQLDao.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import SQLite



final class RoutineWeeklyTrackerSQLDao: RoutineWeeklyTrackerDao{
 
    
    private let db: Connection
    private let table: Table
    
    private let routineId: Expression<UUID>
    private let routineName: Expression<String>
    private let emojiIcon: Expression<String>
    private let tint: Expression<String>
    private let year: Expression<Int?>
    private let weekOfYear: Expression<Int?>
    private let sunday: Expression<Bool?>
    private let monday: Expression<Bool?>
    private let tuesday: Expression<Bool?>
    private let wednesday: Expression<Bool?>
    private let thursday: Expression<Bool?>
    private let friday: Expression<Bool?>
    private let saturday: Expression<Bool?>
    
    
    init(db: Connection) {
        self.db = db
        let routineListTable = Table(RoutineListSQLDao.tableName)
        let routineWeekRecordTable = Table(RoutineWeekRecordSQLDao.tableName)
        
        self.routineId = Expression<UUID>("routineId")
        self.routineName = Expression<String>("routineName")
        self.emojiIcon = Expression<String>("emojiIcon")
        self.tint = Expression<String>("tint")
        self.year = Expression<Int?>("year")
        self.weekOfYear = Expression<Int?>("weekOfYear")
        self.sunday = Expression<Bool?>("sunday")
        self.monday = Expression<Bool?>("monday")
        self.tuesday = Expression<Bool?>("tuesday")
        self.wednesday = Expression<Bool?>("wednesday")
        self.thursday = Expression<Bool?>("thursday")
        self.friday = Expression<Bool?>("friday")
        self.saturday = Expression<Bool?>("saturday")
        
        
        self.table  = routineListTable
            .select( [
                routineListTable[routineId],
                routineListTable[routineName],
                routineListTable[emojiIcon],
                routineListTable[tint],
                routineWeekRecordTable[year],
                routineWeekRecordTable[weekOfYear],
                routineWeekRecordTable[sunday],
                routineWeekRecordTable[monday],
                routineWeekRecordTable[tuesday],
                routineWeekRecordTable[wednesday],
                routineWeekRecordTable[thursday],
                routineWeekRecordTable[friday],
                routineWeekRecordTable[saturday],
            ])
            .join(.leftOuter, routineWeekRecordTable, on: routineListTable[routineId] == routineWeekRecordTable[routineId])
        
    }
    
    func find(year: Int, weekOfYear: Int) throws -> [RoutineWeeklyTrackerDto] {
        let query = table.filter(self.year == year  && self.weekOfYear == weekOfYear)
        
        return try db.prepareRowIterator(query).map {
            RoutineWeeklyTrackerDto(
                routineId: $0[routineId],
                routineName: $0[routineName],
                emojiIcon: $0[emojiIcon],
                tint: $0[tint],
                year: $0[self.year] ?? year,
                weekOfYear: $0[self.weekOfYear] ?? weekOfYear,
                sunday: $0[sunday] ?? false,
                monday: $0[monday] ?? false,
                tuesday: $0[tuesday] ?? false,
                wednesday: $0[wednesday] ?? false,
                thursday: $0[thursday] ?? false,
                friday: $0[friday] ?? false,
                saturday: $0[saturday] ?? false
            )
        }
    }
    
}
