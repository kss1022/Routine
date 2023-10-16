//
//  RoutineBasicInfoFormatter.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation



extension Formatter{
    
    public static let routineBasicInfoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
}
