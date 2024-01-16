//
//  TimerSection.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation

 

struct TimerSection: ValueObject{
    let sectionName: TimerSectionName
    let sectionDescription: TimerSectionDescription
    let timerSectionType: TimerSectionType
    let timerSectionValue: TimerSectionValue
    let sequence: TimerSequence
    let emoji: Emoji
    let tint: Tint

    
    init(command:  CreateSection) throws{
        guard let sectionType = TimerSectionType(rawValue: command.type) else{
            throw ArgumentException("This is not the right data for your type: \(command.type)")
        }
        
        self.timerSectionType = sectionType
        switch self.timerSectionType {
        case .ready, .rest, .exercise, .cycleRest, .cooldown:
            guard let min = command.min, let sec = command.sec else {
                let minMsg = (command.min == nil) ? "nil" : "\(command.min!)"
                let secMsg = (command.sec == nil) ? "nil" : "\(command.sec!)"
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): min = %d  sec = %d" , minMsg, secMsg)
            }
            
            
            let timerCountdown = try TimerSectionCountdown(min: min, sec: sec)
            self.timerSectionValue = .countdown(countdown: timerCountdown)
            
        case .round, .cycle:
            guard let count = command.count else {
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): count = nil")
            }
            
            let timerCount = try TimerSectionCount(count: count)
            self.timerSectionValue = .count(count: timerCount)
        }
        
                    
        
        self.emoji = Emoji(command.emoji)
        self.sectionName = try TimerSectionName(command.name)
        self.sectionDescription = try TimerSectionDescription(command.description)
        self.sequence = try TimerSequence(command.sequence)
        self.tint = Tint(command.color)
    }
    
    init(command:  UpdateSection) throws{
        guard let sectionType = TimerSectionType(rawValue: command.type) else{
            throw ArgumentException("This is not the right data for your type: \(command.type)")
        }
        
        self.timerSectionType = sectionType
        switch self.timerSectionType {
        case .ready, .rest, .exercise, .cycleRest, .cooldown:
            guard let min = command.min, let sec = command.sec else {
                let minMsg = (command.min == nil) ? "nil" : "\(command.min!)"
                let secMsg = (command.sec == nil) ? "nil" : "\(command.sec!)"
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): min = %d  sec = %d" , minMsg, secMsg)
            }
            
            
            let timerCountdown = try TimerSectionCountdown(min: min, sec: sec)
            self.timerSectionValue = .countdown(countdown: timerCountdown)
            
        case .round, .cycle:
            guard let count = command.count else {
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): count = nil")
            }
            
            let timerCount = try TimerSectionCount(count: count)
            self.timerSectionValue = .count(count: timerCount)
        }
        
                    
        
        self.emoji = Emoji(command.emoji)
        self.sectionName = try TimerSectionName(command.name)
        self.sectionDescription = try TimerSectionDescription(command.description)
        self.sequence = try TimerSequence(command.sequence)
        self.tint = Tint(command.tint)
    }
    

    func encode(with coder: NSCoder) {
        sectionName.encode(with: coder)
        sectionDescription.encode(with: coder)
        timerSectionType.encode(with: coder)
        timerSectionValue.encode(with: coder)
        sequence.encode(with: coder)
        emoji.encode(with: coder)
        tint.encode(with: coder)
    }
    
    init?(coder: NSCoder) {
        guard let sectionName = TimerSectionName(coder: coder),
              let sectionDescription = TimerSectionDescription(coder: coder),
              let timerSectionType = TimerSectionType(coder: coder),
              let timerSectionValue = TimerSectionValue(coder: coder, type: timerSectionType),
              let sequence = TimerSequence(coder: coder),
              let emoji = Emoji(coder: coder),
              let tint = Tint(coder: coder)
        else{ return nil }
        
        self.sectionName = sectionName
        self.sectionDescription = sectionDescription
        self.timerSectionType = timerSectionType
        self.timerSectionValue = timerSectionValue
        self.sequence = sequence
        self.emoji = emoji
        self.tint = tint
    }
}




final class EncodableTimerSection: EncodableValueObject{
    
    let timerSection: TimerSection
    
    init(_ timerSection: TimerSection) {
        self.timerSection = timerSection
    }
    
    func encode(with coder: NSCoder) {
        timerSection.encode(with: coder)
    }
    
    init?(coder: NSCoder) {
        guard let timerSection = TimerSection(coder: coder) else { return nil}
        self.timerSection = timerSection
    }
    
    static var supportsSecureCoding: Bool = true
}
