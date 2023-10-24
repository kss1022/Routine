//
//  AppTimer.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation




enum AppTimerState: String {
    case initialized
    case suspended
    case resumed
    case canceled
}


enum AppTimerSectionState{
    case ready
    case rest
    case exercise
    case cycleRest
    case cooldown
}
