//
//  RepeatData.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import Foundation



enum RepeatData{
    case doitOnce(date: Date)
    case daliy
    case weekly(weekly: Set<Weekly>)
    case monhtly(monthly: Set<Monthly>)
    
    
    func data() -> Any?{
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
}


enum Weekly: Int, CaseIterable{
    case Sun = 0
    case Mon = 1
    case Tue = 2
    case Wed = 3
    case Thu = 4
    case Fri = 5
    case Sat = 6
}


struct Monthly: Hashable{
    let day: Int
    
    init(_ day: Int) {
        if !(1...31).contains(day){
            fatalError("Monthy day  must be within 1-31. : \(day)")
        }
        
        self.day = day
    }
}
