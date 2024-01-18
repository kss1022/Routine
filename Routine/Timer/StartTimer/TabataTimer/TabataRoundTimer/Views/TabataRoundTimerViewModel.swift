//
//  TabataRoundTimerViewModel.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation



struct TabataRoundTimerViewModel{
    let emoji: String
    let name: String
    let description: String
    let time: String
        
    
    init(_ model: TimeSectionModel){
        self.emoji = model.emoji
        self.name = model.name
        self.description = model.description
        self.time = TimeInterval(model.min * 60 + model.sec).seconds.time
    }
}
