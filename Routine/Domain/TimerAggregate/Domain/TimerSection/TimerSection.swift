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
    let tint: Tint?

    
    
    
    init(name: String, description: String, sequence: Int, type: String, min: Int?, sec: Int?, count: Int?, emoji: String, color: String?) throws{
                        
        guard let sectionType = TimerSectionType(rawValue: type) else{
            throw ArgumentException("This is not the right data for your type: \(type)")
        }
        
        self.timerSectionType = sectionType
        switch self.timerSectionType {
        case .ready, .rest, .exsercise, .cycleRest, .cooldown:
            guard let min = min, let sec = sec else {
                let minMsg = (min == nil) ? "nil" : "\(min!)"
                let secMsg = (sec == nil) ? "nil" : "\(sec!)"
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): min = %d  sec = %d" , minMsg, secMsg)
            }
            
            if min < 0{
                throw ArgumentException("Minute must bigger then -1")
            }
            
            if sec < 0{
                throw ArgumentException("Second must bigger then -1")
            }
            
            self.timerSectionValue = .countdown(min: min , sec: sec)
        case .round, .cycle:
            guard let count = count else {
                throw ArgumentException("This is not the right data for your type (\(self.timerSectionType.rawValue): count = nil")
            }
            
            if count < 1{
                throw ArgumentException("Count must bigger then 0")
            }
            self.timerSectionValue = .count(count: count)
        }
        
                    
        
        self.emoji = Emoji(emoji)
        self.sectionName = try TimerSectionName(name)
        self.sectionDescription = try TimerSectionDescription(description)
        self.sequence = try TimerSequence(sequence)
        self.tint = color.flatMap(Tint.init)
    }
    

    func encode(with coder: NSCoder) {
        sectionName.encode(with: coder)
        sectionDescription.encode(with: coder)
        timerSectionType.encode(with: coder)
        timerSectionValue.encode(with: coder)
        sequence.encode(with: coder)
        emoji.encode(with: coder)
        tint?.encode(with: coder)
    }
    
    init?(coder: NSCoder) {
        guard let sectionName = TimerSectionName(coder: coder),
              let sectionDescription = TimerSectionDescription(coder: coder),
              let timerSectionType = TimerSectionType(coder: coder),
              let timerSectionValue = TimerSectionValue(coder: coder),
              let sequence = TimerSequence(coder: coder),
              let emoji = Emoji(coder: coder)
        else{ return nil }
        
        self.sectionName = sectionName
        self.sectionDescription = sectionDescription
        self.timerSectionType = timerSectionType
        self.timerSectionValue = timerSectionValue
        self.sequence = sequence
        self.emoji = emoji
        self.tint = Tint(coder: coder)
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
