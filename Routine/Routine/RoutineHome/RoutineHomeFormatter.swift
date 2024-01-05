//
//  RoutineHomeFormatter.swift
//  Routine
//
//  Created by 한현규 on 11/8/23.
//

import Foundation


extension Formatter{
    
            
    public static func routineHomeTitleFormatter(date: Date) -> String{
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            //today
            //dateFommater.dateFormat = "a h:mm"
            return "today".localized(tableName: "Routine")
        }
        
        if calendar.isDateInYesterday(date){
            return "yesterDay".localized(tableName: "Routine")
        }
        
        if calendar.isDateInTomorrow(date){
            return "tomorrow".localized(tableName: "Routine")
        }
        
        
        let dateFomater = DateFormatter()
        
        if calendar.isDate(Date(), equalTo: date, toGranularity: .year){
            //isDateInYear
            dateFomater.dateFormat = "MMM d"
            return dateFomater.string(from: date)
        }
        
        
        dateFomater.dateFormat =  "MMM d yyyy"
        return dateFomater.string(from: date)
    }
            
        
}
