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
    
    
    init(_ model: FocusTimerModel){
        self.emoji = "🧘"
        self.name = model.name
        self.time = TimeInterval(model.minutes).time
    }
    
    init(_ model: TimerTimeIntervalModel){
        self.emoji = model.emoji
        self.name = model.name
        self.time = model.time.focusTime
    }
}
