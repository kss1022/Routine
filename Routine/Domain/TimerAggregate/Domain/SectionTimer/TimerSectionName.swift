//
//  TimerSectionName.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation



struct TimerSectionName: ValueObject{
    let name: String
    
    init(_ name: String) throws{
        if name.count > 50{ throw ArgumentException("TimerSectionName Length must less then 50")  }
        if name.count < 2{ throw ArgumentException("TimerSectionName Length must more then 2")  }
        self.name = name
    }


    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.sectionName.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let sectionName = coder.decodeString(forKey: CodingKeys.sectionName.rawValue) else{
            return nil
        }
        
        self.name = sectionName
    }
    
    
    private enum CodingKeys: String{
        case sectionName
    }
    
    
}
