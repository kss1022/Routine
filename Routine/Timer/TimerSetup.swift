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
        
        let createTabataTimer = CreateSectionTimer(
            name: "running".localized(tableName: "Tutorial"),
            emoji: "🏃",
            tint: "#82B1FFFF",
            timerType: TimerTypeModel.tabata.rawValue,
            createSections: tabataSectionsLists().enumerated().map{ (sequence, section) in
                CreateSection(
                    name: section.name,
                    description: section.description,
                    sequence: sequence,
                    type: section.type.rawValue,
                    min: section.value.min,
                    sec: section.value.sec,
                    count: section.value.count,
                    emoji: section.emoji,
                    color: section.tint
                )
            }
        )
        
        let createRoundTimer = CreateSectionTimer(
            name: "stduy".localized(tableName: "Tutorial"),
            emoji: "🧐",
            tint: "#CAF2BDFF",
            timerType: TimerTypeModel.round.rawValue,
            createSections: roundSectionLists().enumerated().map{ (sequence, section) in
                CreateSection(
                    name: section.name,
                    description: section.description,
                    sequence: sequence,
                    type: section.type.rawValue,
                    min: section.value.min,
                    sec: section.value.sec,
                    count: section.value.count,
                    emoji: section.emoji,
                    color: section.tint
                )
            }
        )
        
        
        try await timerApplicationService.when(createFocusTimer)
        try await timerApplicationService.when(createTabataTimer)
        try await timerApplicationService.when(createRoundTimer)
    }
    
    func tabataSectionsLists() -> [TimerSectionListModel]{
        [
            ready(),
            exercise(),
            rest(),
            round(),
            cycle(),
            cycleRest(),
            cooldown()
        ]
    }
    
    func roundSectionLists() -> [TimerSectionListModel]{
        [
            ready(),
            exercise(),
            rest(),
            round(),
            cooldown(sequence: 4)
        ]
    }
}



private extension TimerSetup{
    func ready() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🔥",
            name: "ready".localized(tableName: "Timer"),
            description: "ready_description".localized(tableName: "Timer"),
            sequence: 0,
            type: .ready,
            value: .countdown(min: 0, sec: 5)
        )
    }
    
    
    func exercise() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🏃‍♂️",
            name: "exercise".localized(tableName: "Timer"),
            description: "exercise_description".localized(tableName: "Timer"),
            sequence: 1,
            type: .exercise,
            value: .countdown(min: 0, sec: 30),
            color: "#3BD2AEff"
        )
    }
    
    func rest() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🧘‍♂️",
            name: "take_a_rest".localized(tableName: "Timer"),
            description: "take_a_rest_description".localized(tableName: "Timer"),
            sequence: 2,
            type: .rest,
            value: .countdown(min: 0, sec: 15),
            color: "#3BD2AEff"
        )
    }
    
    func round() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "⛳️",
            name: "round".localized(tableName: "Timer"),
            description: "round_description".localized(tableName: "Timer"),
            sequence: 3,
            type: .round,
            value: .count(count: 4)
        )
    }
    
    func cycle() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🔄",
            name: "cycle".localized(tableName: "Timer"),
            description: "cycle_description".localized(tableName: "Timer"),
            sequence: 4,
            type: .cycle,
            value: .count(count: 3),
            color: "#6200EEFF"
        )
    }
    
    func cycleRest() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🧘‍♀️",
            name: "cycle_rest".localized(tableName: "Timer"),
            description: "cycle_rest_description".localized(tableName: "Timer"),
            sequence: 5,
            type: .cycleRest,
            value: .countdown(min: 0, sec: 30),
            color: "#6200EEFF"
        )
    }
    
    func cooldown(sequence: Int = 6) -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "❄️",
            name: "colldown".localized(tableName: "Timer"),
            description: "colldown_description".localized(tableName: "Timer"),
            sequence: sequence,
            type: .cooldown,
            value: .countdown(min: 0, sec: 30)
        )
    }
    
    
}

