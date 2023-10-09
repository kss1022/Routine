//
//  RoutineRepeatFormaater.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import Foundation



extension Formatter{
    
            
    public static func asRecentTimeString(date: Date) -> String{
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            //today
            //dateFommater.dateFormat = "a h:mm"
            return "Today"
        }
        
        if calendar.isDateInYesterday(date){
            return "YestureDay"
        }
        
        if calendar.isDateInTomorrow(date){
            return "Tomorrow"
        }
        
        
        let dateFomater = DateFormatter()
        
        if calendar.isDate(Date(), equalTo: date, toGranularity: .year){
            //isDateInYear
            dateFomater.dateFormat = "MMM d"
            return dateFomater.string(from: date)
        }
        
        
        dateFomater.dateFormat =  "yyyy.MM.dd"
        return dateFomater.string(from: date)
    }
            
        
}
