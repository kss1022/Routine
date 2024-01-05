//
//  RoutineName.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



struct RoutineName: ValueObject{
    
    let name: String
    
    init(_ name: String) throws{
        if name.count > 50{ throw ArgumentException("RoutineName Length must less then 50")  }
        if name.count < 2{ throw ArgumentException("RoutineName Length must more then 2")  }
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.routineName.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let name =  coder.decodeString(forKey: CodingKeys.routineName.rawValue) else { return nil}
        self.name = name
    }
        
    private enum CodingKeys: String {
        case routineName = "RoutineName"
    }
}
