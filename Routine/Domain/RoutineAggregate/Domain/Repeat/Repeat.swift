//
//  RoutineRepeat.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation



struct Repeat: ValueObject{
        
    let repeatType: RepeatType
    let repeatValue: RepeatValue
    
    init(repeatType: String, data: Any?) throws{
        guard let repeatType = RepeatType(rawValue: repeatType) else {
            throw ArgumentException("This is not the right data for your type: \(repeatType)")
        }
        
        self.repeatType = repeatType
        
        switch self.repeatType {
        case .doItOnce:
            guard let date = data as? Date else {
                throw ArgumentException("This is not the right data for your type (doItOnce): %@ != %@", "Date", "\(data.self ?? "nil")")
            }
            
            self.repeatValue = .doItOne(date: date)
        case .daliy:
            if data != nil{
                throw ArgumentException("This is not the right data for your type (daliy): Daily value is not nli")
            }
            self.repeatValue = .daliy
        case .weekly:
            guard let weekly = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (weekly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
            }
            
            
            if weekly.isEmpty{
                throw ArgumentException("Weekly is Empty")
            }
            
            for weekDay in weekly{
                if weekDay < 0 || weekDay > 6{
                    throw ArgumentException("Weekly must be in the range 0 ~ 6")
                }
            }

            self.repeatValue = .weekly(weekly: weekly)
        case .monthly:
            guard let monthly = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (monthly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
            }
            
            if monthly.isEmpty{
                throw ArgumentException("Monthly is Empty")
            }
            
            for day in monthly{
                if day < 1 || day > 31{
                    throw ArgumentException("Monthly must be in the range 1 ~ 31")
                }
            }            

            self.repeatValue = .monthly(monthly: monthly)
        }

    }
    
    
    func encode(with coder: NSCoder) {
        repeatType.encode(with: coder)
        repeatValue.encode(with: coder)
    }
    
    init?(coder: NSCoder) {
        guard let type = RepeatType(coder: coder),
              let value = RepeatValue(coder: coder, type: type) else { return nil}
        self.repeatType = type
        self.repeatValue = value
    }
    
    
    static func == (lhs: Repeat, rhs: Repeat) -> Bool {
        (lhs.repeatType == rhs.repeatType) && (lhs.repeatValue == rhs.repeatValue)
    }
}



