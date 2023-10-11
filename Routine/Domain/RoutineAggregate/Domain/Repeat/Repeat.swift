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
            guard let data = data as? Date else {
                throw ArgumentException("This is not the right data for your type (doItOnce): %@ != %@", "Date", "\(data.self ?? "nil")")
            }
            
            self.repeatValue = .doItOne(date: data)
        case .daliy:
            self.repeatValue = .daliy
        case .weekliy:
            guard let weekly = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (weekly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
            }

            self.repeatValue = .weekly(weekly: weekly)
        case .monthly:
            guard let monthly = data as? Set<Int> else {
                throw ArgumentException("This is not the right data for your type (monthly): %@ != %@", "Set<Int>", "\(data.self ?? "nil")")
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



