//
//  RoutineRepeatValue.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



enum RepeatValue: ValueObject{
    case doItOne(date: Date)
    case daliy
    case weekly(weekly: Set<Int>)
    case monthly(monthly: Set<Int>)
    
    
    func encode(with coder: NSCoder) {
        switch self {
        case .doItOne(let date):
            coder.encode(date, forKey: CodingKeys.routineRepeatValue.rawValue)
        case .daliy: break //nothing to do
        case .weekly(let weekly):
            
            coder.encodeSet(Set(weekly.map(Int16.init)), forKey: CodingKeys.routineRepeatValue.rawValue)
        case .monthly(let monthly):
            coder.encodeSet(Set(monthly.map(Int16.init)), forKey: CodingKeys.routineRepeatValue.rawValue)
        }
    }
    
    
    init?(coder: NSCoder) {        
        fatalError("You must use with RepeatType")
    }
    
    init?(coder: NSCoder, type: RepeatType) {
        switch type {
        case .doItOnce:
            let date =  coder.decodeDate(forKey: CodingKeys.routineRepeatValue.rawValue)
            self = .doItOne(date: date)
        case .daliy:
            self = .daliy
        case .weekliy:
            guard let weekly = coder.decodeSet(forKey: CodingKeys.routineRepeatValue.rawValue) else { return nil}
            self = .weekly(weekly: weekly)
        case .monthly:
            guard let monthly = coder.decodeSet(forKey: CodingKeys.routineRepeatValue.rawValue) else { return nil }
            self = .monthly(monthly: monthly)
        }
    }
    
    private enum CodingKeys: String{
        case routineRepeatValue
    }
}
