//
//  RecordFormatter.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation


extension Formatter{
    
    static func recordDate(_ recordDate: RecordDate) -> String{
        "\(recordDate.year)-\(recordDate.month)-\(recordDate.day)"
    }
    
//    static func recordDate(year: Int, month: Int, day: Int) -> String{
//        "\(year)-\(month)-\(day)"
//    }
    
    static func recordMonth(_ recordDate: RecordDate) -> String{
        "\(recordDate.year)-\(recordDate.month)"
    }
        
    
    static func recordDateFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        return formatter
    }
    
    static func recordMonthFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M"
        return formatter
    }
    
    static func weekRecordFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        return formatter
    }
    
}
