//
//  RecordRoutineListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation
import UIKit.UIColor



struct RecordRoutineListViewModel: Hashable{
    
    let routineId: UUID
    let name: String
    let emojiIcon: String
    let tint: UIColor?

    init(_ model: RoutineHomeListModel) {
        self.routineId = model.routineId
        self.name = model.routineName
        self.emojiIcon = model.emojiIcon
        self.tint = UIColor(hex: model.tint)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(routineId)        
        hasher.combine(name)
        hasher.combine(emojiIcon)
        hasher.combine(tint)
    }
    
    static func == (lhs: RecordRoutineListViewModel, rhs: RecordRoutineListViewModel) -> Bool {
        lhs.routineId == rhs.routineId  && lhs.name == rhs.name
        && lhs.emojiIcon == rhs.emojiIcon && lhs.tint == rhs.tint
        
    }
}
