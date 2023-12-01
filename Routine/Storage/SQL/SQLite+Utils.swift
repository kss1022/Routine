//
//  SQLite+Utils.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation
import SQLite




extension Set: Expressible where Element ==  Int{
    
}

extension Set<Int>: Binding , Value{
    public static var declaredDatatype: String{
        String.declaredDatatype
    }
    
    public static func fromDatatypeValue(_ stringValue: String) -> Set<Int> {
        let list = stringValue.components(separatedBy: ",").compactMap(Int.init)
        return Set<Int>(list)
    }
    
    public var datatypeValue: String{
        self.map(String.init).joined(separator: ",")
    }
}
