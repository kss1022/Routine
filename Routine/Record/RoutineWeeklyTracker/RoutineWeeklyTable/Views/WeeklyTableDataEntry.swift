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
    let done: [Bool]
        
    init(_ model: WeeklyTableModel) {
        self.title = model.title
        self.emoji = model.emoji
        self.tint = UIColor(hex: model.tint)
        self.done = model.done
    }
    
}
