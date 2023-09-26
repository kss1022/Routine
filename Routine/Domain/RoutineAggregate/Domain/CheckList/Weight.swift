//
//  Weight.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation





struct Weight: ValueObject{
    let weight: Float
    
    init(_ weight: Float) {
        self.weight = weight
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(weight, forKey: CodingKeys.weight.rawValue)
    }
        
    init?(coder: NSCoder) {                
        self.weight = coder.decodeFloat(forKey: CodingKeys.weight.rawValue)
    }
        
    private enum CodingKeys: String {
        case weight = "Weight"
    }
}
