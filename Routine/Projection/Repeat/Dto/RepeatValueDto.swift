//
//  RepeatValueDto.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



public enum RepeatValueDto{
    case empty
    case date(date: Date)
    case set(set: Set<Int>)
    
    init(_ repeatValue: RepeatValue){
        switch repeatValue {
        case .doItOne(let date):
            self = .date(date: date)
            return
        case .daliy:
            self = .empty
            return
        case .weekly(let weekly):
            self = .set(set: weekly)
        case .monthly(let monthly):
            self = .set(set: monthly)
        }                
    }
}
