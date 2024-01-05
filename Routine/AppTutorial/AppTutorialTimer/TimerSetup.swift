//
//  TimerSetup.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



final class TimerSetup{
    
    private let timerApplicationService: TimerApplicationService    
    
    init(
        timerApplicationService: TimerApplicationService
    ) {
        self.timerApplicationService = timerApplicationService
    }
    
    func initTimer() async throws{
        let createFocusTimer = CreateFocusTimer(
            name: "focus".localized(tableName: "Timer"),
            min: 60
        )
        
        let createTabataTimer = CreateSectionTimer(
            name: "tabata".localized(tableName: "Timer"),
            createSections: [
                ready(),
                rest(),
                exercise(),
                round(),
                cycle(),
                cycleRest(),
                cooldown()
            ].enumerated().map{ (sequence, section) in
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
            name: "round".localized(tableName: "Timer"),
            createSections: [
                ready(),
                rest(),
                exercise(),
                round(),
                cooldown()
            ].enumerated().map{ (sequence, section) in
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
    
    func rest() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🧘‍♂️",
            name: "take_a_rest".localized(tableName: "Timer"),
            description: "take_a_rest_description".localized(tableName: "Timer"),
            sequence: 1,
            type: .rest,
            value: .countdown(min: 1, sec: 10),
            color: "#3BD2AEff"
        )
    }
    
    func exercise() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🏃‍♂️",
            name: "exercise".localized(tableName: "Timer"),
            description: "exercise_description".localized(tableName: "Timer"),
            sequence: 2,
            type: .exercise,
            value: .countdown(min: 0, sec: 5),
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
            value: .count(count: 3)
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
    
    func cooldown() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "❄️",
            name: "colldown".localized(tableName: "Timer"),
            description: "colldown_description".localized(tableName: "Timer"),
            sequence: 6,
            type: .cooldown,
            value: .countdown(min: 0, sec: 30)
        )
    }
    
    
}

