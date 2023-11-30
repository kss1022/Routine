//
//  ProfileIntroduction.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation


struct ProfileIntroduction: ValueObject{
    let introduction: String
    
    init(_ introduction: String) throws {
        if introduction.count > 50{ throw ArgumentException("Profile introduction Length must less then 50")  }
        //if introduction.count < 3{ throw ArgumentException("Profile Description Length must more then 3")  }
        self.introduction = introduction
    }
    

    
    func encode(with coder: NSCoder) {
        coder.encode(introduction, forKey: CodingKeys.introduction.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let introduction = coder.decodeString(forKey: CodingKeys.introduction.rawValue) else { return nil}
        self.introduction = introduction
    }
    
    
    private enum CodingKeys: String{
        case introduction
    }
    
}
