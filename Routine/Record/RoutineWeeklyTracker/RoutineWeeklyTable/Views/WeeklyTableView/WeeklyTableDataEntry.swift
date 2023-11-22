//
//  WeeklyTableViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/11/23.
//

import Foundation



struct WeekTableDataEntry{
    let id: UUID
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(_ viewModel: RecordWeekTableBannerViewModel) {
        self.id = viewModel.id
        self.sunday = viewModel.sunday
        self.monday = viewModel.monday
        self.tuesday = viewModel.tuesday
        self.wednesday = viewModel.wednesday
        self.thursday = viewModel.thursday
        self.friday = viewModel.friday
        self.saturday = viewModel.saturday
    }
    
    
    init(_ viewModel: RoutineWeeklyTableDataEntryViewModel) {
        self.id = viewModel.id
        self.sunday = viewModel.sunday
        self.monday = viewModel.monday
        self.tuesday = viewModel.tuesday
        self.wednesday = viewModel.wednesday
        self.thursday = viewModel.thursday
        self.friday = viewModel.friday
        self.saturday = viewModel.saturday
    }

}
