//
//  TimerSectionType.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



enum TimerSectionType: String, ValueObject{    
    case ready
    case rest
    case exsercise
    case round
    case cycle
    case cycleRest
    case cooldown
    
    func encode(with coder: NSCoder) {
        coder.encode(self.rawValue, forKey: CodingKeys.timerSectionType.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let getType =  coder.decodeString(forKey: CodingKeys.timerSectionType.rawValue),
              let type = TimerSectionType(rawValue: getType) else { return nil }
        self = type
    }
    
    
    private enum CodingKeys: String{
        case timerSectionType
    }
}
