//
//  RecordTimerListModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation




struct RecordTimerListModel{
    let timerId: UUID
    let name: String
    let timerType: RecordTimerTypeModel
    let emoji: String
    let tint: String
    
    init(_ dto: TimerListDto) {
        self.timerId = dto.timerId
        self.name = dto.timerName
        self.timerType = RecordTimerTypeModel(dto.timerType)
        self.emoji = dto.emoji
        self.tint = dto.tint
    }
}
