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
    
    func when(_ command: CreateTimer) async throws{
        do{
            Log.v("When (\(CreateTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let timerType = try TimerType(command.timerType)
            let timerSections = try command.createSectoins.map {
                try TimerSection(
                    name: $0.name,
                    description: $0.description,
                    sequence: $0.sequence,
                    type: $0.type,
                    min: $0.min,
                    sec: $0.sec,
                    count: $0.count,
                    emoji: $0.emoji,
                    color: $0.color
                )
            }
            
            let timer = timerFactory.create(timerId: timerId, timerName: timerName, timerType: timerType, timerSections: timerSections)
            
            //section을 생성해준다.                                    
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
            let timerType = try TimerType(command.timerType)
            
            try update(id: command.timerId) { (timer: Timer) in
                timer.updateTime(timerName: timerName, timerType: timerType)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
}
