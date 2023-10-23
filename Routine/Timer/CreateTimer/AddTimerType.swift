//
//  TimerType.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



enum AddTimerType: String{
    case tabata
    case round
    case custom
    
    var name: String{
        switch self {
        case .tabata: return "Tabata"
        case .round: return "Round"
        case .custom: return "Timer"
        }
    }
    
    var title: String{
        switch self {
        case .tabata: return "Tabata"
        case .round: return "Round"
        case .custom: return "Add Your Timer"
        }
    }
}
