//
//  TimerListDto+SQL.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation
import SQLite


extension TimerTypeDto: Binding, Value{
    
    public static var declaredDatatype: String {
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> TimerTypeDto? {
        TimerTypeDto(rawValue: stringValue)
    }
    
    
    public var datatypeValue: String {
        self.rawValue
    }
    
}
