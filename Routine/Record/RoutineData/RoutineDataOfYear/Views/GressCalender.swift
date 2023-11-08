//
//  GressViewDateHelper.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation




final class GressCalender{
    
    let calendar = Calendar.current
    
    // Year's First day -> WeekDay
    func firstDayToWeekDay(year: Int) -> Int? {
        var components = DateComponents()
        components.year = year
        components.month = 1
        components.day = 1

        if let firstDayOfMonth = Calendar.current.date(from: components) {
            let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
            //sunday : 1 , satureday: 7
            return weekday - 1
        }
        
        return nil
    }
    
    // Month's first day -> days of year
    func dayOfYear(year: Int, month: Int) -> Int?{
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        guard let date =  calendar.date(from: dateComponents) else { return nil}
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)
        return dayOfYear
    }
    
    // Date -> days of year
    func dayOfYear(date: Date) -> Int? {
        if let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: date)) {
            let days = calendar.dateComponents([.day], from: startOfYear, to: date).day
            return days
        }
        return nil
    }
    
}
