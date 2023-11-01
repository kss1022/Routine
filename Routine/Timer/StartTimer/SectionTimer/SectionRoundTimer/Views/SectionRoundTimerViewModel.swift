//
//  SectionRoundTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct SectionRoundTimerViewModel{
    let emoji: String
    let name: String
    let description: String
    let time: String
        
    
    init(_ model: TimerTimeIntervalModel){
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        self.time = model.time.time
    }
}
