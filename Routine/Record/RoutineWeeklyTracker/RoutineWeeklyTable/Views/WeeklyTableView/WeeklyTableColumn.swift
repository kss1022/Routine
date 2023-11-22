//
//  WeeklyTableColumn.swift
//  Routine
//
//  Created by 한현규 on 11/22/23.
//

import Foundation
import UIKit.UIColor



struct WeeklyTableColumn{
    let id: UUID
    let title: String
    let emoji: String
    let tint: UIColor?
    
    init(_ viewModel: RecordWeekTableBannerViewModel) {
        self.id = viewModel.id
        self.title = viewModel.title
        self.emoji = viewModel.emoji
        self.tint = viewModel.tint
    }
    
    init(_ viewModel: RoutineWeeklyTableColumnViewModel){
        self.id = viewModel.id
        self.title = viewModel.title
        self.emoji = viewModel.emoji
        self.tint = viewModel.tint
    }
}
