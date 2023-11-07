//
//  GressViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation



struct GressViewModel{
    let year: Int
    let cellViewModels: [Int: GressCellViewModel]
    let range: ClosedRange<Int>
    
    
    init(year: Int, cellViewModels: [Int : GressCellViewModel]) {
        let calender = GressCalender()
        
        self.year = year
        self.cellViewModels = cellViewModels
        
        let firstWeekdayOfYear = calender.firstDayOfYear(year: year)!
        self.range = firstWeekdayOfYear...(firstWeekdayOfYear + 364)
    }
}
