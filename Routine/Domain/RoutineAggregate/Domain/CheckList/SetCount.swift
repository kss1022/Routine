//
//  SetCount.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation


struct SetCount: ValueObject{
    let count: Int
    
    init(_ count: Int) {
        self.count = count
    }
    
    func encode(with coder: NSCoder) {
        coder.encodeInteger(count, forKey: CodingKeys.count.rawValue)
    }
        
    init?(coder: NSCoder) {
        
        self.count = coder.decodeInteger(forKey: CodingKeys.count.rawValue)
    }
        
    private enum CodingKeys: String {
        case count = "SetCount"
    }
}
