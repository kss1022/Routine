//
//  RecordCalendar.swift
//  Routine
//
//  Created by 한현규 on 11/8/23.
//

import Foundation



final class RecordCalendar{
        
    private let calendar = Calendar.current
    
    static let share = RecordCalendar()
    
    func getDatesForThisWeek() -> [Date] {
        let now = Date()
        var datesInThisWeek: [Date] = []
        
        //First day of the week  ( sunday )
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)),
           let beginningOfWeek = calendar.date(byAdding: .day, value: 1, to: startOfWeek){
            
            //Append Weeks
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: beginningOfWeek) {
                    datesInThisWeek.append(date)
                }
            }
        }else{
            Log.e("Can't get first day of the week")
        }
        
        return datesInThisWeek
    }

}
