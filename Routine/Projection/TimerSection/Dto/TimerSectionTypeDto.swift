//
//  TimerSectionTypeDto.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



enum TimerSectionTypeDto: String{
    case ready
    case rest
    case exsercise
    case round
    case cycle
    case cycleRest
    case cooldown
    
    init(_ timerSectionType: TimerSectionType) {
        switch timerSectionType {
        case .ready: self = .ready
        case .rest: self = .rest
        case .exsercise: self = .exsercise
        case .round: self = .round
        case .cycle: self = .cycle
        case .cycleRest: self = .cycleRest
        case .cooldown: self = .cooldown
        }
    }
}
