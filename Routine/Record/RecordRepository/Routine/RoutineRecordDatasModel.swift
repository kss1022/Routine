//
//  RoutineDetailRecordsModel.swift
//  Routine
//
//  Created by 한현규 on 11/8/23.
//

import Foundation


//TODO: Naming change


struct RoutineRecordDatasModel{
    let completes: [Date: String]    
    let doneThisWeek: RoutineWeekRecordModel?
    let doneThisMonth: Int
    let totalDone: Int
    let bestStreak: Int
    let currentStreak: Int
    
    init(
        records: [RoutineRecordDto],
        totalDto: RoutineTotalRecordDto?,
        monthDto: RoutineMonthRecordDto?,
        weekDto: RoutineWeekRecordDto?,
        bestStreak: RoutineStreakDto?,
        currentStreak: RoutineStreakDto?
    ) {
        var dictionary = [Date: String]()
        let formatter = Formatter.recordDateFormatter()
        
        records.map{ $0.recordDate }
            .forEach{ strDate in
                if let date = formatter.date(from: strDate ){
                    dictionary[date] = strDate
                }
            }
        
        self.completes = dictionary
        self.doneThisWeek = weekDto.flatMap(RoutineWeekRecordModel.init)        
        self.doneThisMonth = monthDto?.done ?? 0
        self.totalDone = totalDto?.totalDone ?? 0
        self.bestStreak = bestStreak?.streakCount ?? 0
        self.currentStreak = currentStreak?.streakCount ?? 0
    }
}
