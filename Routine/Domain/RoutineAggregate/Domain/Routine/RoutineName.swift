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
        if name.count < 3{ throw ArgumentException("RoutineName Length must more then 3")  }
        self.name = name
    }
}
