//
//  TimerListModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct TimerListModel{
    let timerId: UUID
    let name: String
    let emoji: String
    
    init(_ dto: TimerListDto) {
        self.timerId = dto.timerId
        self.name = dto.timerName
        self.emoji = "🏃"
    }
    
    
    init(timerId: UUID, name: String, emoji: String) {
        self.timerId = timerId
        self.name = name
        self.emoji = emoji
    }
    
}
