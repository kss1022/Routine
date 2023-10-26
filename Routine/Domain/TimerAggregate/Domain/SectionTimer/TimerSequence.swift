//
//  TimerSequence.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



struct TimerSequence: ValueObject{
    let sequence: Int
    
    init(_ sequence: Int) throws{
        if sequence < 0{
            throw ArgumentException("Sequence must bigger then -1")
        }
        self.sequence = sequence
    }


    func encode(with coder: NSCoder) {
        coder.encode(sequence, forKey: CodingKeys.timerSequence.rawValue)
    }
    
    init?(coder: NSCoder) {        
        self.sequence = coder.decodeInteger(forKey: CodingKeys.timerSequence.rawValue)
    }
    
    
    private enum CodingKeys: String{
        case timerSequence
    }
    
    

}
