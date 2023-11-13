//
//  GressViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import UIKit.UIColor


struct GressViewModel{
    let year: Int
    let select: Set<Date>
    let range: ClosedRange<Int> //row range
    
    let cellColor: UIColor
    
    //cellViewModels: [Int : GressCellViewModel]
    init(year: Int, selects: Set<Date> = []) {
        let calender = GressCalender()
        
        self.year = year
        self.select = selects                
        let firstWeekdayOfYear = calender.firstDayToWeekDay(year: year)!
        self.range = firstWeekdayOfYear...(firstWeekdayOfYear + 364)
        
        self.cellColor = .primaryColor
    }
}
