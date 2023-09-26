//
//  Tint.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



struct Tint: ValueObject{
    let color: String
    
    init(_ color: String) {
        self.color = color
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(color, forKey: CodingKeys.color.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let color =  coder.decodeString(forKey: CodingKeys.color.rawValue) else { return nil}
        self.color = color
    }
        
    private enum CodingKeys: String {
        case color = "TintColor"
    }
}
