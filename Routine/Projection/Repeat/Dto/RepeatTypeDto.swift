//
//  RepeatTypeDto.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



public enum RepeatTypeDto: String{
    case doItOnce
    case daliy
    case weekliy
    case monthly
    
    init(_ repeatType: RepeatType) {
        switch repeatType {
        case .doItOnce: self = .doItOnce
        case .daliy: self = .daliy
        case .weekliy: self = .weekliy
        case .monthly: self = .monthly
        }
    }
}
