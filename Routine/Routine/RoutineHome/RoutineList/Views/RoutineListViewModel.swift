//
//  RoutineListViewModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import UIKit



struct RoutineListViewModel: Hashable{
    
    let routineId: UUID
    let name: String
    let description: String
    let emojiIcon: String
    let tint: UIColor?
    let isChecked: Bool
    let tapCheckButtonHandler: () -> Void

    init(_ model: RoutineListDto, tapCheckButtonHandler: @escaping () -> Void) {
        self.routineId = model.routineId
        self.name = model.routineName
        self.description = model.routineDescription
        self.emojiIcon = model.emojiIcon
        self.tint = UIColor(hex: model.tint)
        self.isChecked = Bool.random()
        self.tapCheckButtonHandler = tapCheckButtonHandler
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(routineId)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(emojiIcon)
        hasher.combine(tint)
        hasher.combine(isChecked)
    }
    
    static func == (lhs: RoutineListViewModel, rhs: RoutineListViewModel) -> Bool {
        lhs.routineId == rhs.routineId && lhs.name == rhs.name && lhs.description == rhs.description
        && lhs.emojiIcon == rhs.emojiIcon && lhs.tint == rhs.tint && lhs.isChecked == rhs.isChecked
    }
}
