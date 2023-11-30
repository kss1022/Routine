//
//  RepeatModel.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import Foundation



public enum RepeatModel{
    case doitOnce(date: Date)
    case daliy
    case weekly(weekly: Set<Int>)
    case monthly(monthly: Set<Int>)

    init(_ dto: RoutineDetailDto){
        switch dto.repeatType {
        case .doItOnce:
            let date = dto.repeatValue.date()!
            self = .doitOnce(date: date)
        case .daliy:
            self = .daliy
        case .weekly:
            let set = dto.repeatValue.set()!
            self = .weekly(weekly: set)
        case .monthly:
            let set = dto.repeatValue.set()!
            self = .monthly(monthly: set)
        }
    }
    
    
    func rawValue() -> String{
        return switch self {
        case .doitOnce: "doitOnce"
        case .daliy: "daliy"
        case .weekly: "weekly"
        case .monthly: "monthly"
        }
    }
    
    func value() -> Any?{
        switch self {
        case .doitOnce(let date):
            return date
        case .daliy:
            return nil
        case .weekly(let weekly):
            return weekly
        case .monthly(let monthly):
            return monthly
        }
    }
}
