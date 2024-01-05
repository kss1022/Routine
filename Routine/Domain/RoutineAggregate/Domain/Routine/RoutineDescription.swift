//
//  RoutineDescription.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import Foundation


struct RoutineDescription : ValueObject{
    
    
    let description: String
    
    init(description: String) throws {
        if description.count > 50{ throw ArgumentException("RoutineDescription Length must less then 50")  }
        //if description.count < 3{ throw ArgumentException("RoutineDescription Length must more then 3")  }
        self.description = description
    }
    

    
    func encode(with coder: NSCoder) {
        coder.encode(description, forKey: CodingKeys.description.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let description = coder.decodeString(forKey: CodingKeys.description.rawValue) else { return nil}
        self.description = description
    }
    
    
    private enum CodingKeys: String{
        case description = "RoutineDescription"
    }
    
}
