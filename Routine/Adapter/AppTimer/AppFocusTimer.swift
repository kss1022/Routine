//
//  FocusTimer.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation

struct AppFocusTimerModel{
    let min: TimeInterval
    
    init(_ model: FocusTimerModel) {
        self.min = TimeInterval(model.minutes).minute
    }
}


final class AppFocusTimer: BaseTimerImp{
 
    
    var startAt: Date?
    
    init(model: AppFocusTimerModel){
        super.init(time: model.min)
    }
    
    override func start() {
        super.start()
        self.startAt = Date()
    }
}



