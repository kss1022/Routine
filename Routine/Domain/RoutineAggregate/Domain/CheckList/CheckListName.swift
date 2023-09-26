//
//  CheckListName.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



struct CheckListName: ValueObject{
    let name: String
    
    init(_ name: String) throws{
        if name.count > 50{ throw ArgumentException("CheckListName Length must less then 50")  }
        if name.count < 3{ throw ArgumentException("CheckListName Length must more then 3")  }
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.checkListName.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let name =  coder.decodeString(forKey: CodingKeys.checkListName.rawValue)  else { return nil}
        self.name = name
    }
        
    private enum CodingKeys: String {
        case checkListName = "CheckListName"
    }
}
