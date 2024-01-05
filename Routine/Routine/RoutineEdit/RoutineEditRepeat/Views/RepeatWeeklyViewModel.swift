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
    
    func veryShortWeekydaySymbols() -> String {
        Calendar.current.veryShortWeekdaySymbols[self.rawValue]
    }

}
