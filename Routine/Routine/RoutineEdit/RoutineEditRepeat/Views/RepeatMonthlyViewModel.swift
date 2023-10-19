//
//  RepeatMonthlyViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation




struct RepeatMonthlyViewModel: Hashable{
    let day: Int
    
    init(_ day: Int) {
        if !(1...31).contains(day){
            fatalError("Monthy day  must be within 1-31. : \(day)")
        }
        
        self.day = day
    }
}
