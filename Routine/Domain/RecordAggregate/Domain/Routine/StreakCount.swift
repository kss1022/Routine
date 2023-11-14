//
//  StreakCount.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation




struct StreakCount: ValueObject{
    let count: Int
    
    
    init(_ count: Int) throws{
        if count < 0{
            throw ArgumentException("StreakCount must be greater than 0")
        }
        
        self.count = count
    }
    
    func encode(with coder: NSCoder) {
        
    }
    
    init?(coder: NSCoder) {
        nil
    }
    
    
    
    static func +(left: StreakCount, right: Int) -> StreakCount{
        return try! StreakCount(left.count + 1)
    }
    
    static func -(left: StreakCount, right: Int) throws -> StreakCount{
        return try StreakCount(left.count - 1)
    }
    
}
