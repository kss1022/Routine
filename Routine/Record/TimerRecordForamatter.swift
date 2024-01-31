//
//  RecordForamatter.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



extension Formatter{
    static func timerIntervalFormatter(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default

        if let formattedString = formatter.string(from: timeInterval) {
            return formattedString
        } else {
            return ""
        }
    }
    
    static func weekRangeFormatter(date: Date) -> (String, String){
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let startOfWeek = calendar.date(from: components)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        let strStartOfWeek = Formatter.weekRecordFormatter().string(from: startOfWeek)
        let strEndOfWeek = Formatter.weekRecordFormatter().string(from: endOfWeek)
        
        return (strStartOfWeek, strEndOfWeek)
    }
}
