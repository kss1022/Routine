//
//  FocusTimer.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation

struct AppFocusTimerModel{
    let min: TimeInterval
    
    init(_ model: TimerFocusModel) {
        self.min = TimeInterval(model.timerCountdown)
    }
}


final class AppFocusTimer: BaseTimerImp{
 
    
    init(model: AppFocusTimerModel){
        super.init(time: model.min)
    }
    
}



