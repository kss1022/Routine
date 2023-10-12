//
//  RoutineListViewModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import UIKit



struct RoutineListViewModel: Hashable{
    
    let routineId: UUID
    let recordId: UUID?
    let name: String
    let description: String
    let emojiIcon: String
    let tint: UIColor?
    let isCompleted: Bool
    let tapCheckButtonHandler: () -> Void

    init(_ model: RoutineHomeListModel, tapCheckButtonHandler: @escaping () -> Void) {
        self.routineId = model.routineId
        self.recordId = model.recordId
        self.name = model.routineName
        self.description = model.routineDescription
        self.emojiIcon = model.emojiIcon
        self.tint = UIColor(hex: model.tint)
        self.isCompleted = model.isComplete
        self.tapCheckButtonHandler = tapCheckButtonHandler
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(routineId)
        hasher.combine(recordId)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(emojiIcon)
        hasher.combine(tint)
        hasher.combine(isCompleted)
    }
    
    static func == (lhs: RoutineListViewModel, rhs: RoutineListViewModel) -> Bool {
        lhs.routineId == rhs.routineId && rhs.recordId == lhs.recordId && lhs.name == rhs.name && lhs.description == rhs.description
        && lhs.emojiIcon == rhs.emojiIcon && lhs.tint == rhs.tint && lhs.isCompleted == rhs.isCompleted
        
    }
}
