//
//  TimerSectionCount.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



struct TimerSectionCount: ValueObject{
    
    
    let count : Int
    
    init(count: Int) throws {
        if count < 1 || count > 99{
            throw ArgumentException("Count must be in the range 1 ~ 99")
        }
        self.count = count
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encodeInteger(count, forKey: CodingKeys.timerSectionCount.rawValue)
    }
    
    init?(coder: NSCoder) {
        self.count = coder.decodeInteger(forKey: CodingKeys.timerSectionCount.rawValue)
    }
    
    
    private enum CodingKeys: String{
        case timerSectionCount
    }
    

    
    
}
