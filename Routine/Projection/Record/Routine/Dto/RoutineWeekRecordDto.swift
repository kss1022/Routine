//
//  RoutineWeekRecordDto.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation



struct RoutineWeekRecordDto{
    let routineId: UUID
    let startOfWeek: String
    let endOfWeek: String
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(
        routineId: UUID,
        date: Date
    ) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let startOfWeek = calendar.date(from: components)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        let weekFormatter = Formatter.weekRecordFormatter()
        
        self.routineId = routineId
        self.startOfWeek = weekFormatter.string(from: startOfWeek)
        self.endOfWeek = weekFormatter.string(from: endOfWeek)
        self.sunday = false
        self.monday = false
        self.tuesday = false
        self.wednesday = false
        self.thursday = false
        self.friday = false
        self.saturday = false
    }

    
    init(
        routineId: UUID,
        startOfWeek: String,
        endOfWeek: String,
        sunday: Bool = false,
        monday: Bool = false,
        tuesday: Bool = false,
        wednesday: Bool = false,
        thursday: Bool = false,
        friday: Bool = false,
        saturday: Bool = false
    ) {
        self.routineId = routineId
        self.startOfWeek = startOfWeek
        self.endOfWeek = endOfWeek
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
}
