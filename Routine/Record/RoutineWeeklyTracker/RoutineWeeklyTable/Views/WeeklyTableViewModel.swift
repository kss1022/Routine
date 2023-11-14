//
//  WeeklyTableViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import UIKit.UIColor


struct WeeklyTableViewModel{
    let title: String
    let emoji: String
    let tint: UIColor?
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(title: String, emoji: String, tint: String, sunday: Bool, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool) {
        self.title = title
        self.emoji = emoji
        self.tint = UIColor(hex: tint)
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
    init(_ model: RoutineWeeklyTrackerModel) {
        self.title = model.routineName
        self.emoji = model.emojiIcon
        self.tint = UIColor(hex: model.tint)
        self.sunday = model.sunday
        self.monday = model.monday
        self.tuesday = model.tuesday
        self.wednesday = model.wednesday
        self.thursday = model.thursday
        self.friday = model.friday
        self.saturday = model.saturday
    }
    
}
