//
//  TimerSectionCountdown.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



struct TimerSectionCountdown: ValueObject{

    
    let min: Int
    let sec: Int
    
    init(min: Int, sec: Int) throws{
        if min < 0{
            throw ArgumentException("Min must be least than 0")
        }
        
        if sec < 1 || sec > 60{
            throw ArgumentException("Sec must be in the range 1 ~ 60")
        }
        
        self.min = min
        self.sec = sec
    }
    
    func encode(with coder: NSCoder) {
        coder.encodeInteger(min, forKey: CodingKeys.min.rawValue)
        coder.encodeInteger(sec, forKey: CodingKeys.sec.rawValue)
    }
    
    init?(coder: NSCoder) {
        min = coder.decodeInteger(forKey: CodingKeys.min.rawValue)
        sec = coder.decodeInteger(forKey: CodingKeys.sec.rawValue)
    }
    
    
    private enum CodingKeys: String{
        case min
        case sec
    }
    
}
