//
//  TimerSections.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation



struct TimerSections: ValueObject{
            
    let ready: TimerSection
    let exercise: TimerSection
    let rest: TimerSection
    let round: TimerSection
    let cycle: TimerSection?
    let cycleRest: TimerSection?
    let cooldown: TimerSection
    
    init(sections: [TimerSection]) throws{
        
        guard let ready = sections.first(where: { $0.timerSectionType == .ready }),
              let exercise = sections.first(where: { $0.timerSectionType == .exercise }),
              let rest =  sections.first(where: { $0.timerSectionType == .rest }),
              let round = sections.first(where: { $0.timerSectionType == .round}),
              let cooldown = sections.first(where: { $0.timerSectionType == .cooldown}) else {
                throw ArgumentException("Can't find invalid section")
            }
        
        
        let cycle = sections.first(where: { $0.timerSectionType == .cycle })
        let cycleRest = sections.first(where: { $0.timerSectionType == .cycleRest })
        
        if (cycle == nil) != (cycleRest == nil){
            throw ArgumentException("Invalid Cycle, CycleRest State")
        }
        
        
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cycle = cycle
        self.cycleRest = cycleRest
        self.cooldown = cooldown
    }
    
    
    func encode(with coder: NSCoder) {
        var sections = [String: EncodableTimerSection]()
        
        let sectionNum = 7
        sections.reserveCapacity(sectionNum)
        
        sections[TimerSectionType.ready.rawValue] = EncodableTimerSection(ready)
        sections[TimerSectionType.exercise.rawValue] = EncodableTimerSection(exercise)
        sections[TimerSectionType.rest.rawValue] = EncodableTimerSection(rest)
        sections[TimerSectionType.round.rawValue] = EncodableTimerSection(round)
        sections[TimerSectionType.cycle.rawValue] = cycle.map(EncodableTimerSection.init)
        sections[TimerSectionType.cycleRest.rawValue] =  cycleRest.map(EncodableTimerSection.init)
        sections[TimerSectionType.cooldown.rawValue] = EncodableTimerSection(cooldown)
        
        coder.encode(sections, forKey: "\(EncodableTimerSection.self)")
    }
    
    init?(coder: NSCoder) {
        guard let sectinos = coder.decodeDictionary(withKeyClass: NSString.self, objectClass: EncodableTimerSection.self, forKey: "\(EncodableTimerSection.self)"),
              let ready = sectinos[NSString(string: TimerSectionType.ready.rawValue)]?.timerSection,
              let exercise = sectinos[NSString(string: TimerSectionType.exercise.rawValue)]?.timerSection,
              let rest = sectinos[NSString(string: TimerSectionType.rest.rawValue)]?.timerSection,
              let round = sectinos[NSString(string: TimerSectionType.round.rawValue)]?.timerSection,
              let cooldown = sectinos[NSString(string: TimerSectionType.cooldown.rawValue)]?.timerSection
        else { return nil}
        
        self.ready = ready
        self.exercise = exercise
        self.rest = rest
        self.round = round
        self.cycle = sectinos[NSString(string: TimerSectionType.ready.rawValue)]?.timerSection
        self.cycleRest = sectinos[NSString(string: TimerSectionType.ready.rawValue)]?.timerSection
        self.cooldown =  cooldown
    }
    
}
