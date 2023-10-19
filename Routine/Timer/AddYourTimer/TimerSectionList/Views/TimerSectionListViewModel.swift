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
    let value: String
    let color: UIColor?
    
    
    
    init(_ model: TimerSectionListModel) {
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        switch model.value {
        case .countdown(let min, let sec):
            self.value = String(format: "%02d:%02d", min, sec)
        case .count(let count):
            self.value = "\(count)"
        }
        
        self.color  = model.color.flatMap { UIColor(hex: $0) }
    }
}
