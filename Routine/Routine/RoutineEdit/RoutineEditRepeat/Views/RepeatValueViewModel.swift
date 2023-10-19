//
//  RpeatValueViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import Foundation



enum RepeatValueViewModel{
    case doitOnce(date: Date)
    case daliy
    case weekly(weekly: Set<WeekliyViewModel>)
    case monhtly(monthly: Set<RepeatMonthlyViewModel>)
    
    func value() -> Any?{
        switch self {
        case .doitOnce(let date):
            return date
        case .daliy:
            return nil
        case .weekly(let weekly):
            return weekly
        case .monhtly(let monthly):
            return monthly
        }
    }

    
    func rawValue() -> Any?{
        switch self {
        case .doitOnce(let date):
            return date
        case .daliy:
            return nil
        case .weekly(let weekly):
            return  Set(weekly.map { $0.rawValue })
        case .monhtly(let monthly):
            return Set(monthly.map { $0.day })
        }
    }
    
    init?( type: RepeatTypeDto, value: RepeatValueDto){
        switch type {
        case .doItOnce:
            guard let date = value.date() else { return nil }
            self = .doitOnce(date: date)
        case .daliy:
            self = .daliy
        case .weekliy:
            guard let set = value.set() else { return nil }
            let weekly = set.compactMap(WeekliyViewModel.init)
            self = .weekly(weekly: Set(weekly))
        case .monthly:
            guard let set = value.set()  else { return nil }
            let monthly = set.compactMap(RepeatMonthlyViewModel.init)
            self = .monhtly(monthly: Set(monthly))
        }
    }
}


