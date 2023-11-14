//
//  WeeklyTableViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/11/23.
//

import Foundation
import UIKit.UIColor



struct WeeklyTableDataEntry{
    let title: String
    let emoji: String
    let tint: UIColor?
    let weekDataEntry: RoutineTableWeekDataEntry
        
    init(_ viewModel: WeeklyTableViewModel) {
        self.title = viewModel.title
        self.emoji = viewModel.emoji
        self.tint = viewModel.tint
        self.weekDataEntry = RoutineTableWeekDataEntry(viewModel)
    }
    
}


struct RoutineTableWeekDataEntry{
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(_ viewModel: WeeklyTableViewModel) {
        self.sunday = viewModel.sunday
        self.monday = viewModel.monday
        self.tuesday = viewModel.tuesday
        self.wednesday = viewModel.wednesday
        self.thursday = viewModel.thursday
        self.friday = viewModel.friday
        self.saturday = viewModel.saturday
    }
}
