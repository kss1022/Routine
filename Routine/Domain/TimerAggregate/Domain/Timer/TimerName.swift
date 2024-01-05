//
//  TimerName.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



struct TimerName: ValueObject{
    let name: String
    
    init(_ name: String) throws{
        if name.count > 50{ throw ArgumentException("TimerName Length must less then 50")  }
        if name.count < 2{ throw ArgumentException("TimerName Length must more then 2")  }
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.timerName.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let name =  coder.decodeString(forKey: CodingKeys.timerName.rawValue) else { return nil}
        self.name = name
    }
        
    private enum CodingKeys: String {
        case timerName
    }
}
