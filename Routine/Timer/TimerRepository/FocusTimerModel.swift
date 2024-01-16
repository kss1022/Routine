//
//  FocusTimerModel.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation



struct FocusTimerModel{
    let id: UUID
    let name: String
    let emoji: String
    let tint: String
    let minutes : Int
    
    
    init(_ dto: FocusTimerDto){
        self.id = dto.id
        self.name = dto.name
        self.emoji = dto.emoji
        self.tint = dto.tint
        self.minutes = dto.minutes
    }
}
