//
//  TimerNextSectionViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation



struct TimerNextSectionViewModel{
    let name: String
    let description: String
    let time: String
    
    
    init(_ model: TimerTimeIntervalModel) {
        self.name = "\(model.emoji) \(model.name)"
        self.description = model.description
        self.time = String(format:"%02d:%02d", Int(model.time/60), Int(ceil(model.time.truncatingRemainder(dividingBy: 60))) )
    }

    
    init(_ model: TimeSectionModel) {
        self.name = "\(model.emoji) \(model.name)"
        self.description = model.description
        self.time = String(format:"%02d:%02d", model.min, model.sec)
    }

}
