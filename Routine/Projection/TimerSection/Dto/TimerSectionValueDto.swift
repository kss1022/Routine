//
//  TimerSectionValueDto.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



enum TimerSectionValueDto{
    case countdown(min: Int, sec: Int)
    case count(count: Int)
    
    init(_ timerSectionValue: TimerSectionValue){
        switch timerSectionValue {
        case .countdown(let countdown): self = .countdown(min: countdown.min, sec: countdown.sec)
        case .count(let count): self = .count(count: count.count)
        }
    }
}
