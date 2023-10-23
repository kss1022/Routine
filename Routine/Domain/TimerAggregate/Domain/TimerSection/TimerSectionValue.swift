//
//  TimerSectionValue.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



enum TimerSectionValue: ValueObject{

    
    case countdown(min: Int, sec: Int)
    case count(count: Int)
    
    
    func encode(with coder: NSCoder) {
        switch self {
        case .countdown(let min, let sec):
            let totalCountDown = min * 60 + sec
            coder.encodeInteger(totalCountDown, forKey: CodingKeys.timerSectionValue.rawValue)
        case .count(let count):
            coder.encodeInteger(count, forKey: CodingKeys.timerSectionValue.rawValue)
        }
    }
    
    init?(coder: NSCoder) {
        fatalError("You must use with TimerSectionType")
    }
    
    init?(coder: NSCoder, type: TimerSectionType) {
        let value = coder.decodeInteger(forKey: CodingKeys.timerSectionValue.rawValue)
        
        switch type {
        case .ready, .rest, .exsercise, .cycleRest, .cooldown:
            self = .countdown(min: value / 60 , sec: value % 60)
        case .round, .cycle:
            self = .count(count: value)
        }
    }
    
    private enum CodingKeys: String{
        case timerSectionValue
    }
}

