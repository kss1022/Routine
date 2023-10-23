//
//  TimerSectionListViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import UIKit.UIColor


struct TimerSectionListViewModel: Hashable{
    let emoji: String
    let name: String
    let description: String
    let sequence: Int
    let type: TimerSectionTypeModel
    let value: TimerSectionValueModel
    let color: UIColor?
            
    init(_ model: TimerSectionListModel) {        
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        self.sequence = model.sequence
        self.type = model.type        
        self.value = model.value
        self.color  = model.tint.flatMap { UIColor(hex: $0) }
    }

    
}
