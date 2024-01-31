//
//  RecordTimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import Foundation
import UIKit.UIColor



struct RecordTimerListViewModel: Hashable{
    let timerId: UUID
    let name: String
    let emojiIcon: String
    let tint: UIColor?
    
    init(_ model: RecordTimerListModel){
        self.timerId = model.timerId
        self.name = model.name
        self.emojiIcon = model.emoji
        self.tint = UIColor(hex: model.tint)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timerId)
        hasher.combine(name)
        hasher.combine(emojiIcon)
        hasher.combine(tint)
    }
    
    static func == (lhs: RecordTimerListViewModel, rhs: RecordTimerListViewModel) -> Bool {
        lhs.timerId == rhs.timerId  && lhs.name == rhs.name
        && lhs.emojiIcon == rhs.emojiIcon && lhs.tint == rhs.tint
        
    }
}
