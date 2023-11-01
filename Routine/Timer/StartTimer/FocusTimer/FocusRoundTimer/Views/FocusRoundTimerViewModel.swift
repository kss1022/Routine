//
//  FocusRoundTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import Foundation





struct FocusRoundTimerViewModel{
    let emoji: String
    let name: String
    let time: String
    
    
    init(_ model: TimerFocusModel){
        self.emoji = "🧘"
        self.name = model.timerName
        self.time = TimeInterval(model.timerCountdown.minute).time
    }
    
    init(_ model: TimerTimeIntervalModel){
        self.emoji = model.emoji
        self.name = model.name
        self.time = model.time.focusTime
    }
}
