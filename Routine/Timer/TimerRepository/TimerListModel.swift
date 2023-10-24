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
    let timerType: TimerTypeModel
    
    init(_ dto: TimerListDto) {
        self.timerId = dto.timerId
        self.name = dto.timerName
        self.emoji = "🏃"
        self.timerType = TimerTypeModel(dto.timerType)
    }

}


enum TimerTypeModel{
    case tabata
    case round
    case custom
    
    init(_ dto: TimerTypeDto){
        switch dto {
        case .tabata: self = .tabata
        case .round: self = .round
        case .custom: self = .custom
        }
    }
}
