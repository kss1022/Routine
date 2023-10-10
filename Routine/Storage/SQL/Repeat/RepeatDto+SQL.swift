//
//  RoutineRepeatValue.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import Foundation
import SQLite




extension RepeatTypeDto: Binding , Value{
    
    
    public static var declaredDatatype: String {
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> RepeatTypeDto? {
         RepeatTypeDto(rawValue: stringValue)
    }
    
    
    public var datatypeValue: String {
        self.rawValue
    }
        
}


extension RepeatValueDto: Binding, Value{
    public static var declaredDatatype: String{
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> RepeatValueDto? {
        if stringValue.isEmpty{
            return .empty
        }
        
        
        if stringValue.contains(where: { $0 == "-" }){
            guard let date = Formatter.repeatDtoSQLFormatter.date(from: stringValue) else { return nil }
            return .date(date: date)
        }
        
        
        let list = stringValue.components(separatedBy: ",").compactMap(Int.init)
        return .set(set: Set(list))
    }
    
    public var datatypeValue: String{
        switch self {
        case .empty:
            return ""
        case .date(let date):
            return Formatter.repeatDtoSQLFormatter.string(from: date)
        case .set(let set):
            return "\(set.map(String.init).joined(separator: ","))"        
        }
    }
}


extension Formatter{
    fileprivate static let repeatDtoSQLFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
