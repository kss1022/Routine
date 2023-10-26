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
            let timerType = TimerType.section
            
            let sections = try command.createSections.map {
                try TimerSection(command: $0)
            }
            let timerSections = try TimerSections(sections: sections)
            

            let timer = timerFactory.create(timerId: timerId, timerName: timerName, timerType: timerType, timerSections: timerSections)
            
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
            let timerType = TimerType.focus
            let timerCountdown = try TimerFocusCountdown(min: command.min)
            
            let timer = timerFactory.create(timerId: timerId, timerName: timerName, timerType: timerType, timerCountdown: timerCountdown)
                        
            try eventStore.appendToStream(id: timer.timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateTimer) async throws{
        do{
            Log.v("When (\(UpdateTimer.self)):  \(command)")
                        
            let timerName = try TimerName(command.name)
            
            try update(id: command.timerId) { (timer: SectionTimer) in
                timer.updateTime(timerName: timerName)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
}
