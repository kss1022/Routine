//
//  GressViewDateHelper.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation




final class GressCalender{
    
    //그해의 첫번째 요일을 가져온다.
    func firstDayOfYear(year: Int) -> Int? {
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
    
    //해당 달이 그해의 몇번재 날자인지 가져온다.
    func yearOfDay(year: Int, month: Int) -> Int?{
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        guard let date =  calendar.date(from: dateComponents) else { return nil}
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)
        return dayOfYear
    }
}
