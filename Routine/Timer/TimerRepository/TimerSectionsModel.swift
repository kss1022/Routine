//
//  TimerDetailModel.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation




struct TimerSectionsModel{
    let timerId: UUID
    let timerName: String
    let ready: TimerTimeIntervalModel
    let exercise: TimerTimeIntervalModel
    let rest: TimerTimeIntervalModel
    let round: TimerCountModel
    let cycle: TimerCountModel?
    let cycleRest: TimerTimeIntervalModel?
    let cooldown: TimerTimeIntervalModel
    
    init?( timerDto: TimerListDto, sections: [TimerSectionListDto]) {
        self.timerId = timerDto.timerId
        self.timerName = timerDto.timerName
        
        guard let ready = sections.first(where: { $0.timerSectionType == .ready }).flatMap(TimerTimeIntervalModel.init),
              let exercise = sections.first(where: { $0.timerSectionType == .exercise }).flatMap(TimerTimeIntervalModel.init),
              let rest = sections.first(where: { $0.timerSectionType == .rest }).flatMap(TimerTimeIntervalModel.init),
              let round = sections.first(where: { $0.timerSectionType == .round }).flatMap(TimerCountModel.init),
              let cooldown = sections.first(where: { $0.timerSectionType == .cooldown }).flatMap(TimerTimeIntervalModel.init) else { return nil }
        
        let cycle = sections.first(where: { $0.timerSectionType == .cycle }).flatMap(TimerCountModel.init)
        let cycleRest = sections.first(where: { $0.timerSectionType == .cycleRest }).flatMap(TimerTimeIntervalModel.init)
        
        if (cycle == nil) != (cycleRest == nil){
            Log.e("Invalid Cycle, CycleRest State")
            return nil
        }
        
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cycle = cycle
        self.cycleRest = cycleRest
        self.cooldown = cooldown

    }
}



// MARK: Timer Value
struct TimerTimeIntervalModel{
    let time: TimeInterval
    let emoji: String
    let name: String
    let description: String
    let sequence: Int
    
    init?(_ dto: TimerSectionListDto) {
        guard case .countdown(let min, let sec) = dto.timerSectionValue else { return nil}
        self.time = TimeInterval(min + sec)
        self.emoji = dto.emoji
        self.name = dto.sectionName
        self.description = dto.sectionDescription
        self.sequence = dto.sequence
    }
}

struct TimerCountModel{
    let count: Int
    let emoji: String
    let name: String
    let description: String
    let sequence: Int
    
    init?(_ dto: TimerSectionListDto) {
        guard case .count(let count) = dto.timerSectionValue else { return nil}
        self.count = count
        self.emoji = dto.emoji
        self.name = dto.sectionName
        self.description = dto.sectionDescription
        self.sequence = dto.sequence
    }
}
