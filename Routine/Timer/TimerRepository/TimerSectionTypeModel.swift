//
//  TimerSectionTypeModel.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation


enum TimerSectionTypeModel: String{
    case ready
    case rest
    case exercise
    case round
    case cycle
    case cycleRest
    case cooldown
    
    init(_ dto: TimerSectionTypeDto) {
        switch dto {
        case .ready: self = .ready
        case .rest: self = .rest
        case .exercise: self = .exercise
        case .round: self = .round
        case .cycle: self = .cycle
        case .cycleRest: self = .cycleRest
        case .cooldown: self = .cooldown
        }
    }
}
