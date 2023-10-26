//
//  TimerSectionListDto.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



struct TimerSectionListDto{
    let timerId: UUID
    let sectionName: String
    let sectionDescription: String
    let timerSectionType: TimerSectionTypeDto
    let timerSectionValue: TimerSectionValueDto
    let sequence: Int
    let emoji: String
    let tint: String?
    
    init(timerId: TimerId, section: TimerSection) {
        self.timerId = timerId.id
        self.sectionName = section.sectionName.name
        self.sectionDescription = section.sectionDescription.description
        self.timerSectionType = TimerSectionTypeDto(section.timerSectionType)
        self.timerSectionValue = TimerSectionValueDto(section.timerSectionValue)
        self.sequence = section.sequence.sequence
        self.emoji = section.emoji.emoji
        self.tint = section.tint?.color
    }
    
    init(
        timerId: UUID,
        sectionName: String,
        sectionDescription: String,
        timerSectionType: TimerSectionTypeDto,
        timerSectionValue: TimerSectionValueDto,
        sequence: Int,
        emoji: String,
        tint: String?
    ) {
        self.timerId = timerId
        self.sectionName = sectionName
        self.sectionDescription = sectionDescription
        self.timerSectionType = timerSectionType
        self.timerSectionValue = timerSectionValue
        self.sequence = sequence
        self.emoji = emoji
        self.tint = tint
    }
}
