//
//  TimerType.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



enum AddTimerType: String{
    case focus
    case tabata
    case round
    
    
    var name: String{
        switch self {
        case .focus: return "Focus"
        case .tabata: return "Tabata"
        case .round: return "Round"
        }
    }
    
    var title: String{
        switch self {
        case .focus: return "Focus"
        case .tabata: return "Tabata"
        case .round: return "Round"        
        }
    }
}
