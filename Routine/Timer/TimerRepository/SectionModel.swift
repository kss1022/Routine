//
//  TimeSectionModel.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation




struct TimeSectionModel{
    let name: String
    let description: String
    let min: Int
    let sec: Int
    let emoji: String
    let tint: String
}

struct RepeatSectionModel{
    let name: String
    let description: String
    let `repeat`: Int
    let emoji: String
    let tint: String
}


extension TimeSectionCommand{
    init(_ model: TimeSectionModel){
        self.name = model.name
        self.description = model.description
        self.min = model.min
        self.sec = model.sec
        self.emoji = model.emoji
        self.tint = model.tint
    }
}

extension RepeatSectionCommand{
    init(_ model: RepeatSectionModel){
        self.name = model.name
        self.description = model.description
        self.repeat = model.repeat
        self.emoji = model.emoji
        self.tint = model.tint
    }
}


extension TimeSectionModel{
    func timeInterval() -> TimeInterval{
        TimeInterval(self.min * 60 + self.sec).seconds
    }
}
