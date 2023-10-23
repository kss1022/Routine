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
        case .countdown(let min, let sec): self = .countdown(min: min, sec: sec)
        case .count(let count): self = .count(count: count)
        }
    }
}
