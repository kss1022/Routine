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
}
