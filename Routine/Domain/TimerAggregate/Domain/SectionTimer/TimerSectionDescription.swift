//
//  TimerSectionDescription.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation


struct TimerSectionDescription: ValueObject{
    let description: String
    
    init(_ description: String) throws{
        if description.count > 50{ throw ArgumentException("TimerSectionDescription Length must less then 50")  }
        self.description = description
    }


    func encode(with coder: NSCoder) {
        coder.encode(description, forKey: CodingKeys.description.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let description = coder.decodeString(forKey: CodingKeys.description.rawValue) else{
            return nil
        }
        
        self.description = description
    }
    
    
    private enum CodingKeys: String{
        case description
    }
    
    

}
