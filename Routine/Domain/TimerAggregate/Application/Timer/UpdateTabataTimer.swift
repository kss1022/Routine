//
//  UpdateTabataTimer.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation



struct UpdateTabataTimer: Command{
    let id: UUID
    let name: String
    let emoji: String
    let tint: String
    let ready: TimeSectionCommand
    let exercise: TimeSectionCommand
    let rest: TimeSectionCommand
    let round: RepeatSectionCommand
    let cycle: RepeatSectionCommand
    let cycleRest: TimeSectionCommand
    let cooldown: TimeSectionCommand
}
