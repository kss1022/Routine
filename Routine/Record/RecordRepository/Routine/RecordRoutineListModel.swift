//
//  RecordRoutineListModel.swift
//  Routine
//
//  Created by 한현규 on 11/22/23.
//

import Foundation



struct RecordRoutineListModel{
    let routineId: UUID
    let routineName: String
    let emojiIcon: String
    let tint: String
    
    init(dto: RoutineListDto) {
        self.routineId = dto.routineId
        self.routineName = dto.routineName
        self.emojiIcon = dto.emojiIcon
        self.tint = dto.tint
    }
}
