//
//  TimerNextSectionModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



struct TimerNextSectionModel{
    let emoji: String
    let name: String
    let description: String
    let value: TimerSectionValueModel
    let color: String?
    
    
    init(emoji: String, name: String, description: String, value: TimerSectionValueModel, color: String? = nil) {
        self.emoji = emoji
        self.name = name
        self.description = description
        self.value = value
        self.color = color
    }
}
