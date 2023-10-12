//
//  RecordFormatter.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation


extension Formatter{
    
    static func recordDate(year: Int, month: Int, day: Int) -> String{
        "\(year)-\(month)-\(day)"
    }
    
    static func recordFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-d"
        return formatter
    }
    
}
