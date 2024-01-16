//
//  TabataTimerModel.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation


struct TabataTimerModel{
    let id: UUID
    let name: String
    let emoji: String
    let tint: String
    
    
    let ready: TimeSectionModel
    let exercise: TimeSectionModel
    let rest: TimeSectionModel
    let round: RepeatSectionModel
    let cycle: RepeatSectionModel
    let cycleRest: TimeSectionModel
    let cooldown: TimeSectionModel
    
    init(_ dto: TabataTimerDto) {
        self.id = dto.id
        self.name = dto.name
        self.emoji = dto.emoji
        self.tint = dto.tint
        
        self.ready = TimeSectionModel(
            name: dto.readyName,
            description: dto.readyDescription,
            min: dto.readyMin,
            sec: dto.readySec,
            emoji: dto.readyEmoji,
            tint: dto.readyTint
        )
        self.exercise = TimeSectionModel(
            name: dto.exerciseName,
            description: dto.exerciseDescription,
            min: dto.exerciseMin,
            sec: dto.exerciseSec,
            emoji: dto.exerciseEmoji,
            tint: dto.exerciseTint
        )
        self.rest = TimeSectionModel(
            name: dto.restName,
            description: dto.restDescription,
            min: dto.restMin,
            sec: dto.restSec,
            emoji: dto.restEmoji,
            tint: dto.restTint
        )
        self.round = RepeatSectionModel(
            name: dto.roundName,
            description: dto.roundDescription,
            repeat: dto.roundRepeat,
            emoji: dto.roundEmoji,
            tint: dto.roundTint
        )
        self.cycle = RepeatSectionModel(
            name: dto.cycleName,
            description: dto.cycleDescription,
            repeat: dto.cycleRepeat,
            emoji: dto.cycleEmoji,
            tint: dto.cycleTint
        )
        self.cycleRest = TimeSectionModel(
            name: dto.cycleRestName,
            description: dto.cycleRestDescription,
            min: dto.cycleRestMin,
            sec: dto.cycleRestSec,
            emoji: dto.cycleRestEmoji,
            tint: dto.cycleRestTint
        )
        self.cooldown = TimeSectionModel(
            name: dto.cooldownName,
            description: dto.cooldownDescription,
            min: dto.cooldownMin,
            sec: dto.cooldownSec,
            emoji: dto.cooldownEmoji,
            tint: dto.cooldownTint
        )
    }
}
