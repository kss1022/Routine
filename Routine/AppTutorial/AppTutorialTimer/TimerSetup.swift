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
            name: "Focus",
            min: 60
        )
        
        let createTabataTimer = CreateSectionTimer(
            name: "Tabata",
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
            name: "Round",
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
            name: "Ready",
            description: "Before start countdown",
            sequence: 0,
            type: .ready,
            value: .countdown(min: 0, sec: 5)
        )
    }
    
    func rest() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🧘‍♂️",
            name: "Take a rest",
            description: "Take a rest",
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
            name: "Excercise",
            description: "You can do it!!!",
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
            name: "Round",
            description: "Round is excersise + rest",
            sequence: 3,
            type: .round,
            value: .count(count: 3)
        )
    }
    
    func cycle() -> TimerSectionListModel{
        TimerSectionListModel(
            id: UUID(),
            emoji: "🔄",
            name: "Cycle",
            description: "Cycle is \(3) round",
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
            name: "Cycle Rest",
            description: "Take a rest",
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
            name: "Cool Down",
            description: "After excersice cool down",
            sequence: 6,
            type: .cooldown,
            value: .countdown(min: 0, sec: 30)
        )
    }
    
    
}

