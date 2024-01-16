//
//  TimerSectionListModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


struct TimerSectionListModel{
    let name: String
    let description: String
    let emoji: String
    let tint: String
    let type: TimerSectionTypeModel
    let value: TimerSectionValueModel
}


struct TabataSectionListsModel{
    let ready: TimeSectionModel
    let exercise: TimeSectionModel
    let rest: TimeSectionModel
    let round: RepeatSectionModel
    let cycle: RepeatSectionModel
    let cycleRest: TimeSectionModel
    let cooldown: TimeSectionModel
}



struct RoundSectionListsModel{
    let ready: TimeSectionModel
    let exercise: TimeSectionModel
    let rest: TimeSectionModel
    let round: RepeatSectionModel
    let cooldown: TimeSectionModel
}


extension TabataSectionListsModel{
    func sectionLists() -> [TimerSectionListModel]{
        [
            self.ready.sectionList(.ready),
            self.exercise.sectionList(.exercise),
            self.rest.sectionList(.rest),
            self.round.sectionList(.round),
            self.cycle.sectionList(.cycle),
            self.cycleRest.sectionList(.cycleRest),
            self.cooldown.sectionList(.cooldown),
        ]
    }
}

extension RoundSectionListsModel{
    func sectionLists() -> [TimerSectionListModel]{
        [
            self.ready.sectionList(.ready),
            self.exercise.sectionList(.exercise),
            self.rest.sectionList(.rest),
            self.round.sectionList(.round),
            self.cooldown.sectionList(.cooldown),
        ]
    }
}


extension TimerSectionListModel{
    func toTimeSectionModel() -> TimeSectionModel{
        TimeSectionModel(
            name: name,
            description: description,
            min: value.min!,
            sec: value.sec!,
            emoji: emoji,
            tint: tint
        )
    }
    
    func toRepeatSectionModel() -> RepeatSectionModel{
        RepeatSectionModel(
            name: name,
            description: description,
            repeat: value.count!,
            emoji: emoji,
            tint: tint
        )
    }
}

fileprivate extension TimeSectionModel{
    func sectionList(_ type: TimerSectionTypeModel) -> TimerSectionListModel{
        TimerSectionListModel(
            name: name,
            description: description,
            emoji: emoji,
            tint: tint,
            type: type,
            value: .countdown(min: min, sec: sec)
        )
    }
}

fileprivate extension RepeatSectionModel{
    func sectionList(_ type: TimerSectionTypeModel) -> TimerSectionListModel{
        TimerSectionListModel(
            name: name,
            description: description,
            emoji: emoji,
            tint: tint,
            type: type,
            value: .count(count: `repeat`)
        )
    }
}
