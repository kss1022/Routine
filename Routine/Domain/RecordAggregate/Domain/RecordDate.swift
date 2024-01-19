//
//  RecordDate.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


struct RecordDate: ValueObject, Hashable{
    let date: Date
    let year: Int
    let month: Int
    let day: Int
    let dayOfWeek: Int
    
    init(_ date: Date) throws{
        let calendar = Calendar.current
        if calendar.startOfDay(for: date) != date{
            throw ArgumentException("Date is not start of Day")
        }
        
        
        self.date = date
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        dayOfWeek = calendar.component(.weekday, from: date) - 1
    }
    
    

    func encode(with coder: NSCoder) {
        coder.encodeDate(date, forKey: CodingKeys.date.rawValue)
        coder.encodeInteger(year, forKey: CodingKeys.year.rawValue)
        coder.encodeInteger(month, forKey: CodingKeys.month.rawValue)
        coder.encodeInteger(day, forKey: CodingKeys.day.rawValue)        
        coder.encodeInteger(dayOfWeek, forKey: CodingKeys.dayOfWeek.rawValue)
    }

    init?(coder: NSCoder) {
        guard let date = coder.decodeDate(forKey: CodingKeys.date.rawValue) else{
            return nil
        }
        self.date = date
        self.year = coder.decodeInteger(forKey: CodingKeys.year.rawValue)
        self.month = coder.decodeInteger(forKey: CodingKeys.month.rawValue)
        self.day = coder.decodeInteger(forKey: CodingKeys.day.rawValue)
        self.dayOfWeek = coder.decodeInteger(forKey: CodingKeys.dayOfWeek.rawValue)
    }

    private enum CodingKeys: String{
        case date
        case year
        case month
        case day
        case dayOfWeek
    }

    
}



