//
//  TimerTypeDto.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation


enum TimerTypeDto: String{
    case tabata
    case round
    case custom
    
    init(timerType: TimerType){
        switch timerType {
        case .tabata: self = .tabata
        case .round: self = .round
        case .custom: self = .custom
        }
    }
}
