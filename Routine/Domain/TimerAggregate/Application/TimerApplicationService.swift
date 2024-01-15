//
//  TimerApplicationService.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class TimerApplicationService: ApplicationService{
    
    
    internal var eventStore: EventStore
    internal var snapshotRepository: SnapshotRepository
    
    private let timerFactory: TimerFactory
    
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        timerFactory: TimerFactory) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.timerFactory = timerFactory
    }
    
    func when(_ command: CreateSectionTimer) async throws{
        do{
            Log.v("When (\(CreateSectionTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = try TimerType(timerType: command.timerType)
            
            let sections = try command.createSections.map {
                try TimerSection(command: $0)
            }
            let timerSections = try TimerSections(sections: sections)
            


            let timer = timerFactory.create(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerSections: timerSections)
            
            //section을 생성해준다.                                    
            try eventStore.appendToStream(id: timer.timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
        
    }
    
    func when(_ command: CreateFocusTimer) async throws{
        do{
            Log.v("When (\(CreateFocusTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.focus
            let timerCountdown = try TimerFocusCountdown(min: command.min)
            
            let timer = timerFactory.create(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerCountdown: timerCountdown)
                        
            try eventStore.appendToStream(id: timer.timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateSectionTimer) async throws{
        do{
            Log.v("When (\(UpdateSectionTimer.self)):  \(command)")
                        
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let sections = try command.updateSections.map {
                try TimerSection(command: $0)
            }
            let timerSections = try TimerSections(sections: sections)
            

            try update(id: command.timerId) { (timer: SectionTimer) in
                timer.updateTimer(timerName: timerName, emoji: emoji, tint: tint, timerSections: timerSections)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: UpdateFocusTimer) async throws{
        do{
            Log.v("When (\(UpdateFocusTimer.self)):  \(command)")
            
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.focus
            let timerCountdown = try TimerFocusCountdown(min: command.min)
         
            try update(id: command.timerId) { (timer: FocusTimer) in
                timer.updateTimer(timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerCountdown: timerCountdown)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: DeleteSectionTimer) async throws{
        do{
            Log.v("When (\(DeleteSectionTimer.self)):   \(command)")
            
            try update(id: command.timerId) { (timer: SectionTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
        
    }
    
    func when(_ command: DeleteFocusTimer) async throws{
        do{
            Log.v("When (\(DeleteFocusTimer.self)):   \(command)")
            
            try update(id: command.timerId) { (timer: FocusTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
        
    }
}
