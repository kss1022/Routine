//
//  TimerSectionListModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



struct TimerSectionListModel{
    let id: UUID
    let emoji: String
    let name: String
    let description: String
    let value: TimerSectionValue
    let color: String?
    
    
    init(id: UUID, emoji: String, name: String, description: String, value: TimerSectionValue, color: String? = nil) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.description = description
        self.value = value
        self.color = color
    }
}
