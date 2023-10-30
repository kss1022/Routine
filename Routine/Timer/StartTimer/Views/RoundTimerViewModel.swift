//
//  RoundTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct RoundTimerViewModel{
    let emoji: String
    let name: String
    let description: String
    let time: String
    //let duration: TimeInterval
    
    
    init(_ model: TimerFocusModel){
        self.emoji = "🧘"
        self.name = model.timerName
        self.description = "Countdown"
        self.time = TimeInterval(model.timerCountdown).time
    }
    
    init(_ model: TimerTimeIntervalModel){
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        self.time = model.time.time
    }
}
