//
//  TimerSectionValue.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



enum TimerSectionValue: ValueObject{

    
    case countdown(countdown: TimerSectionCountdown)
    case count(count: TimerSectionCount)
    
    
    func encode(with coder: NSCoder) {
        switch self {
        case .countdown(let countdown):
            countdown.encode(with: coder)
        case .count(let count):
            count.encode(with: coder)
        }
    }
    
    init?(coder: NSCoder) {
        fatalError("You must use with TimerSectionType")
    }
    
    init?(coder: NSCoder, type: TimerSectionType) {
        let value = coder.decodeInteger(forKey: CodingKeys.timerSectionValue.rawValue)
        
        switch type {
        case .ready, .rest, .exercise, .cycleRest, .cooldown:
            guard let countdown = TimerSectionCountdown(coder: coder) else { return nil }
            self = .countdown(countdown: countdown)
        case .round, .cycle:
            guard let count = TimerSectionCount(coder: coder) else { return nil }
            self = .count(count: count)
        }
    }
    
    private enum CodingKeys: String{
        case timerSectionValue
    }
}

