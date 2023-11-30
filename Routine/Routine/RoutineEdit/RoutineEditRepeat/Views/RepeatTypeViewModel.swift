//
//  RepeatTypeViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation



enum RepeatTypeViewModel: String{
    case doItOnce
    case daliy
    case weekly
    case monthly
    
    init(_ model: RepeatModel){
        switch model {
        case .doitOnce: self = .doItOnce
        case .daliy: self = .daliy
        case .weekly: self = .weekly
        case .monthly: self = .monthly
        }
    }
}
