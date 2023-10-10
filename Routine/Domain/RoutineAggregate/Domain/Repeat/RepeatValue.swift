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
            coder.encode(weekly, forKey: CodingKeys.routineRepeatValue.rawValue)
        case .monthly(let monthly):
            coder.encode(monthly, forKey: CodingKeys.routineRepeatValue.rawValue)
        }
    }
    
    
    init?(coder: NSCoder) {
        //nothing to do
        nil
    }
    
    init?(coder: NSCoder, type: RepeatType) {
        switch type {
        case .doItOnce:
            let date =  coder.decodeDate(forKey: CodingKeys.routineRepeatValue.rawValue)
            self = .doItOne(date: date)
        case .daliy:
            self = .daliy
        case .weekliy:
            let weekly = coder.decodeSet(forKey: CodingKeys.routineRepeatValue.rawValue)
            self = .weekly(weekly: Set(weekly.compactMap { $0 as? Int }))
        case .monthly:
            let monthly = coder.decodeSet(forKey: CodingKeys.routineRepeatValue.rawValue)
            self = .monthly(monthly: Set(monthly.compactMap { $0 as? Int }))
        }
    }
    
    private enum CodingKeys: String{
        case routineRepeatValue
    }
}
