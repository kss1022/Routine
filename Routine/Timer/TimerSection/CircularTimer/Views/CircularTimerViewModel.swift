//
//  CircularTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct CircularTimerViewModel{
    let emoji: String
    let name: String
    let description: String
    let time: String
    let duration: TimeInterval
    
    
    init(_ model: TimerTimeIntervalModel){
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        self.time = String(format:"%02d:%02d", Int(model.time/60), Int(ceil(model.time.truncatingRemainder(dividingBy: 60))) )

        self.duration = model.time
    }
}
