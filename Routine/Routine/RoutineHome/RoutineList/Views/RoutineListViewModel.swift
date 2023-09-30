//
//  RoutineListViewModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import UIKit



struct RoutineListViewModel{
    let name: String
    let description: String
    let emojiIcon: String
    let color: UIColor?
    let isChecked: Bool
    let tapHandler: () -> Void
    let tapCheckButtonHandler: () -> Void

    init(_ model: RoutineListDto, _ tapHandler: @escaping () -> Void, tapCheckButtonHandler: @escaping () -> Void) {
        self.name = model.routineName
        self.description = model.routineDescription
        self.emojiIcon = model.emojiIcon
        self.color = UIColor(hex: model.tint)
        self.isChecked = Bool.random()
        self.tapHandler = tapHandler
        self.tapCheckButtonHandler = tapCheckButtonHandler
    }
}
