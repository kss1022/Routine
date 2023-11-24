//
//  ProfileName.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



struct ProfileName: ValueObject{
    
    let name: String
    
    init(_ name: String) throws{
        if name.count > 30{
            throw ArgumentException("ProfileName Length must less then 30")
        }
        
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.prifleName.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let name =  coder.decodeString(forKey: CodingKeys.prifleName.rawValue) else { return nil}
        self.name = name
    }
        
    private enum CodingKeys: String {
        case prifleName
    }
}
