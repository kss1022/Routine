//
//  RepeatSegmentType.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation



enum RepeatSegmentType{
    case none
    case daliy
    case weekliy
    case monthly
}



enum Weekly: String, CaseIterable{
    case Sun
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
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
