//
//  WeeklyViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


enum WeeklyViewModel: Int, CaseIterable{
    case Sun = 0
    case Mon = 1
    case Tue = 2
    case Wed = 3
    case Thu = 4
    case Fri = 5
    case Sat = 6
    
    func label() -> String{
        switch self {
        case .Sun: return "Sun"
        case .Mon: return "Mon"
        case .Tue: return "Tue"
        case .Wed: return "Wed"
        case .Thu: return "Thu"
        case .Fri: return "Fri"
        case .Sat: return "Sat"
        }
    }
}
