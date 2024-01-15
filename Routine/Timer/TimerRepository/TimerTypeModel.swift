//
//  TimerTypeModel.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation


enum TimerTypeModel: String{
    case focus
    case tabata
    case round
    
    init(_ dto: TimerTypeDto){
        switch dto {
        case .focus: self = .focus
        case .tabata: self = .tabata
        case .round: self = .round
        }
    }
}
