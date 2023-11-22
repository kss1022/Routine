//
//  PreferenceKeys+Timer.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



extension PreferenceKeys {
    
    var showsTimerTutorial : PrefKey<Bool>{ .init(name: "kShowTimerTutorial") }
    
    var timerSetup: PrefKey<Bool>{ .init(name: "kTimerSetup")}
    var timerId: PrefKey<String>{ .init(name: "kTimerId")}
    
}

