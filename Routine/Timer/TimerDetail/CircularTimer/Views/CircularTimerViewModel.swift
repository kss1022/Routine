//
//  CircularTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct CircularTimerViewModel{
    let id: UUID
    let emoji: String
    let name: String
    let description: String
    let time: String
    let duration: TimeInterval
    
    init?(_ model: TimerSectionListModel){
        guard case .countdown(let min, let sec) = model.value else {
            return nil
        }
        
        self.id = model.timerId!
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        

        self.time = String(format: "%02d:%02d", min, sec)
        self.duration = TimeInterval(min * 60 + sec)
    }
}
