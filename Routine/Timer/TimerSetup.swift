//
//  TimerSetup.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



final class TimerSetup{
        
    
    func initTimer(_ timerApplicationService: TimerApplicationService) async throws{
        let createFocusTimer = CreateFocusTimer(
            name: "tomato".localized(tableName: "Tutorial"),
            emoji: "🍅",
            tint: "#F5B7CCFF",
            min: 30
        )
        
        let createTabataTimer = CreateTabataTimer(
            name: "running".localized(tableName: "Tutorial"),
            emoji: "🏃",
            tint: "#82B1FFFF",
            ready: TimeSectionCommand(ready()),
            exercise: TimeSectionCommand(exercise()),
            rest: TimeSectionCommand(rest()),
            round: RepeatSectionCommand(round()),
            cycle: RepeatSectionCommand(cycle()),
            cycleRest: TimeSectionCommand(cycleRest()),
            cooldown: TimeSectionCommand(cooldown())
        )
        
        
        let createRoundTimer = CreateRoundTimer(
            name: "study".localized(tableName: "Tutorial"),
            emoji: "🧐",
            tint: "#CAF2BDFF",
            ready: TimeSectionCommand(ready()),
            exercise: TimeSectionCommand(exercise()),
            rest: TimeSectionCommand(rest()),
            round: RepeatSectionCommand(round()),
            cooldown: TimeSectionCommand(cooldown())
        )
        
        try await timerApplicationService.when(createFocusTimer)
        try await timerApplicationService.when(createTabataTimer)
        try await timerApplicationService.when(createRoundTimer)
    }
        

}


extension TimerSetup{
    
    func ready() -> TimeSectionModel{
        TimeSectionModel(
            name: "ready".localized(tableName: "Timer"),
            description: "ready_description".localized(tableName: "Timer"),
            min: 0,
            sec: 5,
            emoji: "🔥",
            tint: "#F5B7CCFF"
        )
    }
    
    
    func exercise() -> TimeSectionModel{
        TimeSectionModel(
            name: "exercise".localized(tableName: "Timer"),
            description: "exercise_description".localized(tableName: "Timer"),
            min: 0,
            sec: 30,
            emoji: "🏃‍♂️",
            tint: "#3BD2AEff"
        )
    }
    
    func rest() -> TimeSectionModel{
        TimeSectionModel(
            name: "take_a_rest".localized(tableName: "Timer"),
            description: "take_a_rest_description".localized(tableName: "Timer"),
            min: 0,
            sec: 15,
            emoji: "🧘‍♂️",
            tint: "#3BD2AEff"
        )
    }
    
    func round() -> RepeatSectionModel{
        RepeatSectionModel(
            name: "round".localized(tableName: "Timer"),
            description: "round_description".localized(tableName: "Timer"),
            repeat: 3,
            emoji: "⛳️",
            tint: "#F5DAAFFF"
        )
    }
    
    func cycle() -> RepeatSectionModel{
        RepeatSectionModel(
            name: "cycle".localized(tableName: "Timer"),
            description: "cycle_description".localized(tableName: "Timer"),
            repeat: 3,
            emoji: "🔄",
            tint: "#6200EEFF"
        )
    }
    
    func cycleRest() -> TimeSectionModel{
        TimeSectionModel(
            name: "cycle_rest".localized(tableName: "Timer"),
            description: "cycle_rest_description".localized(tableName: "Timer"),
            min: 0,
            sec: 30,
            emoji: "🧘‍♂️",
            tint: "#6200EEFF"
        )
    }
    
    func cooldown(sequence: Int = 6) -> TimeSectionModel{
        TimeSectionModel(
            name: "colldown".localized(tableName: "Timer"),
            description: "colldown_description".localized(tableName: "Timer"),
            min: 0,
            sec: 30,
            emoji: "❄️",
            tint: "#82B1FFFF"
        )
    }
    
    
}
