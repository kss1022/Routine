//
//  TimerSectionDto+SQL.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation
import SQLite


extension TimerSectionTypeDto: Binding, Value{
    
    public static var declaredDatatype: String {
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> TimerSectionTypeDto? {
        TimerSectionTypeDto(rawValue: stringValue)
    }
    
    
    public var datatypeValue: String {
        self.rawValue
    }
    
}


extension TimerSectionValueDto: Binding, Value{
    public static var declaredDatatype: String{
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> TimerSectionValueDto? {
        if stringValue.contains(where: { $0 == ":" }){
            let countDown = stringValue.components(separatedBy: ":").compactMap(Int.init)
            
            return .countdown(min: countDown[safe: 0] ?? 0, sec: countDown[safe: 1] ?? 0)
        }
        
        
        return .count(count: Int(stringValue) ?? 0)
    }
    
    public var datatypeValue: String{
        switch self {
        case .countdown(let min, let sec):
            return "\(min):\(sec)"
        case .count(let count):
            return "\(count)"
        }
    }

    
}
