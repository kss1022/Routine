//
//  TimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//


import Foundation
import UIKit.UIColor


struct TimerListViewModel: Hashable{
    
    
    let timerId: UUID
    let name: String
    let description: String
    let emojiIcon: String
    let tintColor: UIColor?
    let tapHandler: () -> Void
    
    init(_ model: TimerListModel, tapHandler: @escaping () -> Void) {
        self.timerId = model.timerId
        self.name = model.name
        self.description = model.timerType.rawValue.localized(tableName: "Timer")        
        self.emojiIcon = model.emoji
        self.tintColor = UIColor(hex: model.tint)
        self.tapHandler = tapHandler
    }
    
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timerId)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(emojiIcon)
    }
    
    
    static func == (lhs: TimerListViewModel, rhs: TimerListViewModel) -> Bool {
        lhs.timerId == rhs.timerId && lhs.name == rhs.name &&
        lhs.description == rhs.description && lhs.emojiIcon == rhs.emojiIcon &&
        lhs.tintColor == rhs.tintColor
    }

}
