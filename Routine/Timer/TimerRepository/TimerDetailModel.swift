//
//  TimerDetailModel.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation




struct TimerDetailModel{
    let timerId: UUID
    let timerName: String
    //let timerType: TimerTypeModel
    let repeatModel: TimerRepeatModel
    
    init?( timerDto: TimerListDto, sections: [TimerSectionListDto]) {
        self.timerId = timerDto.timerId
        self.timerName = timerDto.timerName
        
        let timerType = TimerTypeModel(timerDto.timerType)
        
        
        switch timerType {
        case .tabata:
            if sections.count != 7{
                Log.e("Invalid Section Count Tabata must be 7:  sections.count = \(sections.count)")
                return nil
            }
            
            if !(sections[0].timerSectionType == .ready || sections[1].timerSectionType == .rest ||
                sections[2].timerSectionType == .exsercise || sections[3].timerSectionType == .round ||
                sections[4].timerSectionType == .cycle || sections[5].timerSectionType == .cycleRest ||
                sections[6].timerSectionType == .cooldown){
                Log.e("Invalid Section Type of List index: \(sections)")
                return nil
            }
            

            guard let readyModel = TimerTimeIntervalModel(sections[0]),
                  let restModel = TimerTimeIntervalModel(sections[1]),
                  let exerciseModel = TimerTimeIntervalModel(sections[2]),
                  let roundModel = TimerCountModel(sections[3]),
                  let cycleModel = TimerCountModel(sections[4]),
                  let cycleRestModel = TimerTimeIntervalModel(sections[5]),
                  let cooldownModel = TimerTimeIntervalModel(sections[6]) else { return nil}
            
            
            let timer =  BaseTimerModel(
                ready: readyModel,
                exercise: exerciseModel,
                rest: restModel,
                round: roundModel,
                cycle: cycleModel,
                cycleRest: cycleRestModel,
                cooldown: cooldownModel
            )
            self.repeatModel = .base(model: timer)
        case .round:
            if sections.count != 5{
                Log.e("Invalid Section Count Round must be 5:  sections.count = \(sections.count)")
                return nil
            }
            
            if !(sections[0].timerSectionType == .ready || sections[1].timerSectionType == .rest ||
                sections[2].timerSectionType == .exsercise || sections[3].timerSectionType == .round ||
                sections[4].timerSectionType == .cooldown){
                Log.e("Invalid Section Type of List index: \(sections)")
                return nil
            }
            

            guard let readyModel = TimerTimeIntervalModel(sections[0]),
                  let restModel = TimerTimeIntervalModel(sections[1]),
                  let exerciseModel = TimerTimeIntervalModel(sections[2]),
                  let roundModel = TimerCountModel(sections[3]),
                  let cooldownModel = TimerTimeIntervalModel(sections[4]) else { return nil}
            
            let timer = BaseTimerModel(
                ready: readyModel,
                exercise: exerciseModel,
                rest: restModel,
                round: roundModel,
                cooldown: cooldownModel
            )
            self.repeatModel = .base(model: timer)
        case .custom:
            self.repeatModel = .custom(model: CustomTimerModel())
        }
    }
}



// MARK: Repeat Model
enum TimerRepeatModel{
    case base(model: BaseTimerModel)
    case custom(model: CustomTimerModel)
}


//
//struct RoundModel{
//    let ready: TimerTimeIntervalModel
//    let exercise: TimerTimeIntervalModel
//    let rest: TimerTimeIntervalModel
//    let round: TimerCountModel
//    let cooldown: TimerTimeIntervalModel
//}

struct BaseTimerModel{
    let ready: TimerTimeIntervalModel
    let exercise: TimerTimeIntervalModel
    let rest: TimerTimeIntervalModel
    let round: TimerCountModel
    let cycle: TimerCountModel?
    let cycleRest: TimerTimeIntervalModel?
    let cooldown: TimerTimeIntervalModel
    
    init(ready: TimerTimeIntervalModel, exercise: TimerTimeIntervalModel, rest: TimerTimeIntervalModel, round: TimerCountModel, cycle: TimerCountModel? = nil, cycleRest: TimerTimeIntervalModel? = nil, cooldown: TimerTimeIntervalModel) {
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cycle = cycle
        self.cycleRest = cycleRest
        self.cooldown = cooldown
    }
}

struct CustomTimerModel{
    
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
