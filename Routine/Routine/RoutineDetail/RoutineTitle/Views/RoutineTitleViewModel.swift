//
//  RoutineTitleViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation



struct RoutineTitleViewModel{
    let emojiIcon: String
    let routineName: String
    let routineDescription: String
    
    init(_ dto: RoutineDetailModel) {
        self.emojiIcon = dto.emojiIcon
        self.routineName = dto.routineName
        self.routineDescription = dto.routineDescription
    }
}
