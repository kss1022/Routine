//
//  WeeklyTableViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import UIKit.UIColor



struct RoutineWeeklyTableColumnViewModel{
    let id: UUID
    let title: String
    let emoji: String
    let tint: UIColor?
    
    init(_ model: RecordRoutineListModel) {
        self.id = model.routineId
        self.title = model.routineName
        self.emoji = model.emojiIcon
        self.tint = UIColor(hex: model.tint)
    }
}


struct RoutineWeeklyTableDataEntryViewModel{
    let id: UUID
    let startOfWeek: String
    let endOfWeek: String
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(_ model: RoutineWeekRecordModel) {
        self.id = model.routineId
        self.startOfWeek = model.startOfWeek
        self.endOfWeek = model.endOfWeek
        self.sunday = model.sunday
        self.monday = model.monday
        self.tuesday = model.tuesday
        self.wednesday = model.wednesday
        self.thursday = model.thursday
        self.friday = model.friday
        self.saturday = model.saturday
    }
}
