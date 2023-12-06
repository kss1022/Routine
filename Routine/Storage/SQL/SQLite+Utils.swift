//
//  SQLite+Utils.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation
import SQLite


import Foundation
import SQLite

protocol SQLiteConverter{
    init?(datatypeValue: String)
    var dataTypeValue: String{ get }
}

struct ARRAY<T>: Expressible, Value where T : SQLiteConverter{
    typealias Datatype = String

    static var declaredDatatype: String {

        return String.declaredDatatype
    }

    let array: [T]

    init(_ array: [T]) {
        self.array = array
    }

    static func fromDatatypeValue(_ datatypeValue: String) -> ARRAY<T> {
        // Deserialize the string and create a CustomArray instance
        let array = datatypeValue.components(separatedBy: ",").compactMap(T.init)
        return ARRAY(array)
    }

    var datatypeValue: String {
        // Serialize the array to a string
        let stringValue = self.array.map { $0.dataTypeValue }.joined(separator: ",")
        return stringValue
    }
}


struct SET<T>: Expressible, Value where T : SQLiteConverter & Hashable{
    typealias Datatype = String

    static var declaredDatatype: String {
        return String.declaredDatatype
    }

    let set: Set<T>

    init(_ array: [T]) {
        self.set = Set(array)
    }
    
    init(_ set: Set<T>){
        self.set = set
    }

    static func fromDatatypeValue(_ datatypeValue: String) -> SET<T> {
        // Deserialize the string and create a CustomArray instance
        let set = datatypeValue.components(separatedBy: ",").compactMap(T.init)
        return SET(set)
    }

    var datatypeValue: String {
        // Serialize the array to a string
        let stringValue = self.set.map { $0.dataTypeValue }.joined(separator: ",")
        return stringValue
    }
}





extension Int: SQLiteConverter{
    init?(datatypeValue: String){
        guard let toInt = Int(datatypeValue) else{
            return nil
        }
        self = toInt
    }
    
    var dataTypeValue: String{ String(self) }
}

extension String: SQLiteConverter{
    init?(datatypeValue: String) {
        self = datatypeValue
    }
    
    var dataTypeValue: String{ self }
}
