//
//  TimerFocusCountdown.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation




struct TimerFocusCountdown: ValueObject{
    let min: Int
    
    init(min: Int) throws{
        if min <= 0{
            throw ArgumentException("Min must be equal to or greater than 0")
        }
                
        self.min = min
    }
    
    func encode(with coder: NSCoder) {
        coder.encodeInteger(min, forKey: CodingKeys.timerFocusCountdown.rawValue)
    }
    
    init?(coder: NSCoder) {
        self.min = coder.decodeInteger(forKey: CodingKeys.timerFocusCountdown.rawValue)
    }
    
    private enum CodingKeys: String{
        case timerFocusCountdown
    }
}
