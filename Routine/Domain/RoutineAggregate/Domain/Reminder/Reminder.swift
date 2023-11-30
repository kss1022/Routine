//
//  Reminder.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation


struct Reminder: ValueObject{
    let year: Int?
    let month: Int?
    let day: Int?
    let weekDays: Set<Int>?
    let monthDays: Set<Int>?
    let hour: Int
    let minute: Int
    
    init(
        repeatType: String,
        data: Any?,
        hour: Int,
        minute: Int
    ) throws {
        guard let repeatType = RepeatType(rawValue: repeatType) else {
            throw ArgumentException("This is not the right data for your type: \(repeatType)")
        }
        
                
        switch repeatType {
        case .doItOnce:
            guard let date = data as? Date else {
                throw ArgumentException("This is not the right data for your type (doItOnce): %@ != %@", "Date", "\(data.self ?? "nil")")
            }
            
            let calendar = Calendar.current
            self.year = calendar.component(.year, from: date)
            self.month = calendar.component(.month, from: date)
            self.day = calendar.component(.day, from: date)
            self.weekDays = nil
            self.monthDays = nil
        case .daliy: 
            self.year = nil
            self.month = nil
            self.day = nil
            self.weekDays = nil
            self.monthDays = nil
        case .weekly:
            guard let weekDays = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (weekly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
            }
            
            
            if weekDays.isEmpty{
                throw ArgumentException("WeekDays is Empty")
            }
            
            for weekDay in weekDays{
                if weekDay < 0 || weekDay > 6{
                    throw ArgumentException("Weekly must be in the range 0 ~ 6")
                }
            }

            self.year = nil
            self.month = nil
            self.day = nil
            self.weekDays = weekDays
            self.monthDays = nil
        case .monthly:
            guard let monthDays = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (monthly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
            }
            
            if monthDays.isEmpty{
                throw ArgumentException("MonthkDays is Empty")
            }
            
            for day in monthDays{
                if day < 1 || day > 31{
                    throw ArgumentException("Monthly must be in the range 1 ~ 31")
                }
            }

            self.year = nil
            self.month = nil
            self.day = nil
            self.weekDays = nil
            self.monthDays = monthDays
        }
        
        
        self.hour = hour
        self.minute = minute
    }
    
    func encode(with coder: NSCoder) {
        if let year = year,
           let month = month,
           let day = day{
            coder.encodeInteger(year, forKey: CodingKeys.year.rawValue)
            coder.encodeInteger(month, forKey: CodingKeys.month.rawValue)
            coder.encodeInteger(day, forKey: CodingKeys.day.rawValue)
            
        }
        
        
        if let weekDay = weekDays{
            coder.encodeSet(Set(weekDay.map(Int16.init)), forKey: CodingKeys.weekDays.rawValue)
        }
        
        if let monthDay = monthDays{
            coder.encodeSet(Set(monthDay.map(Int16.init)), forKey: CodingKeys.monthDays.rawValue)
        }
        
        coder.encode(hour, forKey: CodingKeys.hour.rawValue)
        coder.encode(minute, forKey: CodingKeys.minute.rawValue)
    }
    
    init?(coder: NSCoder) {
        self.year =  coder.decodeInteger(forKey: CodingKeys.year.rawValue)
        self.month = coder.decodeInteger(forKey: CodingKeys.month.rawValue)
        self.day = coder.decodeInteger(forKey: CodingKeys.day.rawValue)
        
        //Set(weekly.compactMap { $0 as? Int })
    
        if let weekDays = coder.decodeSet(forKey: CodingKeys.weekDays.rawValue){
            self.weekDays = Set(weekDays)
        }else{
            self.weekDays = nil
        }
        
        if let monthDays = coder.decodeSet(forKey: CodingKeys.monthDays.rawValue){
            self.monthDays = Set(monthDays)
        }else{
            self.monthDays = nil
        }
        
        self.hour = coder.decodeInteger(forKey: CodingKeys.hour.rawValue)
        self.minute = coder.decodeInteger(forKey: CodingKeys.minute.rawValue)
    }
    
    private enum CodingKeys: String{
        case year
        case month
        case day
        case weekDays
        case monthDays
        case hour
        case minute
    }
    
}
