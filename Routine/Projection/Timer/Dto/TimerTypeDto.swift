//
//  TimerTypeDto.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation


enum TimerTypeDto: String{
    case focus
    case section
    
    init(_ timerType: TimerType){
        switch timerType {
        case .focus: self = .focus
        case .section: self = .section
        }
    }
}
