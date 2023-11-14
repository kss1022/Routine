//
//  RoutineTopAcheiveModel.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation



struct RoutineTopAcheiveModel{
    let routineName: String
    let emojiIcon: String
    let tint: String
    let totalDone: Int
    let bestStreak: Int
    
    init(dto: RoutineTopAcheiveDto){
        routineName = dto.routineName
        emojiIcon = dto.emojiIcon
        tint = dto.tint
        totalDone = dto.totalDone
        bestStreak = dto.bestStreak
    }
}
