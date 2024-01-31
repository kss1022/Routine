//
//  RecordTimerTypeModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation




enum RecordTimerTypeModel: String{
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
