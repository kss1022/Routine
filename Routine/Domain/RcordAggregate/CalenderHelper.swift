//
//  CalenderHelper.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation


final class CalenderHelper{
    let calender = Calendar.current
    
    func plushMonth(date : Date) -> Date{
        return calender.date(byAdding: .month, value: 1 , to: date)!
    }
    
    func minusMonth(date : Date) -> Date{
        return calender.date(byAdding: .month, value: -1,to: date)!
    }
    
    func monthString(date :Date) -> Int{
//        let dateFormmatter = DateFormatter()
//        dateFormmatter.dateFormat = "LLLL"
//        return dateFormmatter.string(from: date)
        return calender.component(.month, from: date)
    }
    
    func yearString(date :Date) -> Int{
//        let dateFormmatter = DateFormatter()
//        dateFormmatter.dateFormat = "yyyy"
//        return dateFormmatter.string(from: date)
        return calender.component(.year, from: date)
    }
    
    func daysInMonth(date :Date) -> Int{
        let range = calender.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date : Date) ->Int{
        
        let components = calender.dateComponents([.day] , from : date)
        return components.day!
    }
    
    func firstOfMonth(date : Date) -> Date{
        let components = calender.dateComponents([.year, .month] , from : date)
        return calender.date(from: components)!
    }
    
    func weekDay(date : Date) -> Int{
        let components = calender.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
}


public class DateHelper {
    class func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minute: Int = 0, seconds: Int = 0) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: "\(year)-\(month)-\(day) \(hour):\(minute):\(seconds)")
    }
    
    class func dateAfter(years: Int, from baseDate: Date) -> Date? {
        let yearsToAdd = years
        var dateComponents = DateComponents()
        dateComponents.year = yearsToAdd
        return Calendar.current.date(byAdding: dateComponents, to: baseDate)
    }
    
    /// 가능한 날짜 설정
    class func getYearList() -> [Int] {
        /// 선택 가능한 연도 설정
        let formatterYear = DateFormatter()
        formatterYear.dateFormat = "yyyy"
        let todayYear : Int = Int( formatterYear.string(from: Date()) ) ?? 2022
        return Array( 2022...todayYear + 5)
    }
}
