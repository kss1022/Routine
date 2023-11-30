//
//  CreateRoutineModel.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation




struct CreateRoutineModel: Hashable{
                
    let name: String
    let description: String
    let repeatModel: RepeatModel
    let reminderTime: (Int, Int)?
    let emoji: String
    let tint: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(emoji)
    }
    
    static func == (lhs: CreateRoutineModel, rhs: CreateRoutineModel) -> Bool {
        lhs.name == rhs.name  && lhs.emoji == rhs.emoji
    }
}
