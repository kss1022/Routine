//
//  RoundTimerDto.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation



struct RoundTimerDto{
    let id: UUID
    let name: String
    let emoji: String
    let tint: String
        
    let readyName: String
    let readyDescription: String
    let readyEmoji: String
    let readyTint: String
    let readyMin: Int
    let readySec: Int
    
    let exerciseName: String
    let exerciseDescription: String
    let exerciseEmoji: String
    let exerciseTint: String
    let exerciseMin: Int
    let exerciseSec: Int
    
    let restName: String
    let restDescription: String
    let restEmoji: String
    let restTint: String
    let restMin: Int
    let restSec: Int
    
    let roundName: String
    let roundDescription: String
    let roundEmoji: String
    let roundTint: String
    let roundRepeat: Int
    
    let cooldownName: String
    let cooldownDescription: String
    let cooldownEmoji: String
    let cooldownTint: String
    let cooldownMin: Int
    let cooldownSec: Int
    
    
    init(_ event: RoundTimerCreated) {
        self.id = event.timerId.id
        self.name = event.timerName.name
        self.emoji = event.emoji.emoji
        self.tint = event.tint.color
        self.readyName = event.ready.name
        self.readyDescription = event.ready.description
        self.readyEmoji = event.ready.emoji
        self.readyTint = event.ready.tint
        self.readyMin = event.ready.min
        self.readySec = event.ready.sec
        self.exerciseName = event.exercise.name
        self.exerciseDescription = event.exercise.description
        self.exerciseEmoji = event.exercise.emoji
        self.exerciseTint = event.exercise.tint
        self.exerciseMin = event.exercise.min
        self.exerciseSec = event.exercise.sec
        self.restName = event.rest.name
        self.restDescription = event.rest.description
        self.restEmoji = event.rest.emoji
        self.restTint = event.rest.tint
        self.restMin = event.rest.min
        self.restSec = event.rest.sec
        self.roundName = event.round.name
        self.roundDescription = event.round.description
        self.roundEmoji = event.round.emoji
        self.roundTint = event.round.tint
        self.roundRepeat = event.round.repeat
        self.cooldownName = event.cooldown.name
        self.cooldownDescription = event.cooldown.description
        self.cooldownEmoji = event.cooldown.emoji
        self.cooldownTint = event.cooldown.tint
        self.cooldownMin = event.cooldown.min
        self.cooldownSec = event.cooldown.sec
    }

    init(_ event: RoundTimerUpdated) {
        self.id = event.timerId.id
        self.name = event.timerName.name
        self.emoji = event.emoji.emoji
        self.tint = event.tint.color
        self.readyName = event.ready.name
        self.readyDescription = event.ready.description
        self.readyEmoji = event.ready.emoji
        self.readyTint = event.ready.tint
        self.readyMin = event.ready.min
        self.readySec = event.ready.sec
        self.exerciseName = event.exercise.name
        self.exerciseDescription = event.exercise.description
        self.exerciseEmoji = event.exercise.emoji
        self.exerciseTint = event.exercise.tint
        self.exerciseMin = event.exercise.min
        self.exerciseSec = event.exercise.sec
        self.restName = event.rest.name
        self.restDescription = event.rest.description
        self.restEmoji = event.rest.emoji
        self.restTint = event.rest.tint
        self.restMin = event.rest.min
        self.restSec = event.rest.sec
        self.roundName = event.round.name
        self.roundDescription = event.round.description
        self.roundEmoji = event.round.emoji
        self.roundTint = event.round.tint
        self.roundRepeat = event.round.repeat
        self.cooldownName = event.cooldown.name
        self.cooldownDescription = event.cooldown.description
        self.cooldownEmoji = event.cooldown.emoji
        self.cooldownTint = event.cooldown.tint
        self.cooldownMin = event.cooldown.min
        self.cooldownSec = event.cooldown.sec
    }

    
    init(id: UUID, name: String, emoji: String, tint: String, readyName: String, readyDescription: String, readyEmoji: String, readyTint: String, readyMin: Int, readySec: Int, exerciseName: String, exerciseDescription: String, exerciseEmoji: String, exerciseTint: String, exerciseMin: Int, exerciseSec: Int, restName: String, restDescription: String, restEmoji: String, restTint: String, restMin: Int, restSec: Int, roundName: String, roundDescription: String, roundEmoji: String, roundTint: String, roundRepeat: Int, cooldownName: String, cooldownDescription: String, cooldownEmoji: String, cooldownTint: String, cooldownMin: Int, cooldownSec: Int) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.tint = tint
        self.readyName = readyName
        self.readyDescription = readyDescription
        self.readyEmoji = readyEmoji
        self.readyTint = readyTint
        self.readyMin = readyMin
        self.readySec = readySec
        self.exerciseName = exerciseName
        self.exerciseDescription = exerciseDescription
        self.exerciseEmoji = exerciseEmoji
        self.exerciseTint = exerciseTint
        self.exerciseMin = exerciseMin
        self.exerciseSec = exerciseSec
        self.restName = restName
        self.restDescription = restDescription
        self.restEmoji = restEmoji
        self.restTint = restTint
        self.restMin = restMin
        self.restSec = restSec
        self.roundName = roundName
        self.roundDescription = roundDescription
        self.roundEmoji = roundEmoji
        self.roundTint = roundTint
        self.roundRepeat = roundRepeat
        self.cooldownName = cooldownName
        self.cooldownDescription = cooldownDescription
        self.cooldownEmoji = cooldownEmoji
        self.cooldownTint = cooldownTint
        self.cooldownMin = cooldownMin
        self.cooldownSec = cooldownSec
    }
    
    
}
