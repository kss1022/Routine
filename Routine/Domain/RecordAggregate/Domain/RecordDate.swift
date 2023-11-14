//
//  RecordDate.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


struct RecordDate: ValueObject, Hashable{
    let startOfDay: Date
    let year: Int
    let month: Int
    let day: Int
    let weekOfYear: Int
    let dayOfWeek: Int
    
    init(_ date: Date){
        let calendar = Calendar.current
        self.startOfDay = calendar.startOfDay(for: date)
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        weekOfYear = calendar.dateComponents([.weekOfYear], from: date).weekOfYear!
        dayOfWeek = calendar.component(.weekday, from: date) - 1
    }
    
    

    func encode(with coder: NSCoder) {
        coder.encodeDate(startOfDay, forKey: CodingKeys.startOfDay.rawValue)
        coder.encodeInteger(year, forKey: CodingKeys.year.rawValue)
        coder.encodeInteger(month, forKey: CodingKeys.month.rawValue)
        coder.encodeInteger(day, forKey: CodingKeys.day.rawValue)
        coder.encodeInteger(weekOfYear, forKey: CodingKeys.weekOfYear.rawValue)
        coder.encodeInteger(dayOfWeek, forKey: CodingKeys.dayOfWeek.rawValue)
    }

    init?(coder: NSCoder) {
        guard let date = coder.decodeDate(forKey: CodingKeys.startOfDay.rawValue) else{
            return nil
        }
        self.startOfDay = date
        self.year = coder.decodeInteger(forKey: CodingKeys.year.rawValue)
        self.month = coder.decodeInteger(forKey: CodingKeys.month.rawValue)
        self.day = coder.decodeInteger(forKey: CodingKeys.day.rawValue)
        self.weekOfYear = coder.decodeInteger(forKey: CodingKeys.weekOfYear.rawValue)
        self.dayOfWeek = coder.decodeInteger(forKey: CodingKeys.dayOfWeek.rawValue)
    }

    private enum CodingKeys: String{
        case startOfDay
        case year
        case month
        case day
        case weekOfYear
        case dayOfWeek
    }

    
}



