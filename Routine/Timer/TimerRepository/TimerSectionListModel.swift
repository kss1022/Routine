//
//  TimerSectionListModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



struct TimerSectionListModel{
    let timerId: UUID?
    let emoji: String
    let name: String
    let description: String
    let sequence: Int
    let type: TimerSectionTypeModel
    let value: TimerSectionValueModel
    let tint: String?
    
    
    init(_ dto: TimerSectionListDto){
        self.timerId = dto.timerId
        self.emoji = dto.emoji
        self.name = dto.sectionName
        self.sequence = dto.sequence
        self.description = dto.sectionDescription
        self.type = TimerSectionTypeModel(dto.timerSectionType)
        self.value = TimerSectionValueModel(dto.timerSectionValue)
        self.tint = dto.tint
    }
    
    
    init(id: UUID? = nil, emoji: String, name: String, description: String, sequence: Int,type: TimerSectionTypeModel, value: TimerSectionValueModel, color: String? = nil) {
        self.timerId = id
        self.emoji = emoji
        self.name = name
        self.sequence = sequence
        self.description = description
        self.type = type
        self.value = value
        self.tint = color
    }
}
