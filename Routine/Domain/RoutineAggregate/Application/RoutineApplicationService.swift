//
//  RoutineApplicationService.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



final class RoutineApplicationService : ApplicationService{
    
    internal let eventStore: EventStore
    internal let snapshotRepository: SnapshotRepository
    
    private let routineFactory: RoutineFactory
    private let routineService: RoutineService
    
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        routineFactory: RoutineFactory,
        routineService: RoutineService
    ) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.routineFactory = routineFactory
        self.routineService = routineService        
    }
    
    
    
    func when(_ command: CreateRoutine) async throws{
        do{
            Log.v("When (\(CreateRoutine.self)):  \(command)")
            
            let routineId = RoutineId(UUID())
            let routineName = try RoutineName(command.name)
            let routineDescription = try RoutineDescription(description: command.description)
            let `repeat` = try Repeat(repeatType: command.repeatType, data: command.repeatValue)
            let reminder =  try command.reminderTime.map {
                try Reminder(repeatType: command.repeatType, data: command.repeatValue, hour: $0.0,minute: $0.1)
            }
            let icon = Emoji(command.emoji)
            let tint = Tint(command.tint)
                                                
            let routine = routineFactory.create(routineId: routineId, routineName: routineName, routineDescription: routineDescription, repeat: `repeat`, reminder: reminder, icon: icon, tint: tint)
                        
            try eventStore.appendToStream(id: routine.routineId.id, expectedVersion: -1, events: routine.changes)
            try Transaction.commit()

        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateRoutine) async throws{
        do{
            Log.v("When (\(UpdateRoutine.self)):  \(command)")
            
            let routineName = try RoutineName(command.name)
            let routineDescription = try RoutineDescription(description: command.description)
            let `repeat` = try Repeat(repeatType: command.repeatType, data: command.repeatValue)
            let reminder =  try command.reminderTime.map {
                try Reminder(repeatType: command.repeatType, data: command.repeatValue, hour: $0.0,minute: $0.1)
            }
            let icon = Emoji(command.emoji)
            let tint = Tint(command.tint)
         
            try update(id: command.routineId) { (routine: Routine) in
                routine.updateRoutine(
                    routineName,
                    routineDescription: routineDescription, 
                    repeat: `repeat`, 
                    reminder: reminder,
                    emoji: icon,
                    tint: tint
                )
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: ChangeRoutineName) async throws{
        do{
            let routineName = try RoutineName(command.routineName)
            
            try update(id: command.routineId) { (routine: Routine) in
                routine.changeRoutineName(routineName)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: DeleteRoutine) async throws{
        do{
            Log.v("When (\(DeleteRoutine.self)):  \(command)")
            
            try update(id: command.routineId) {  (routine: Routine) in
                routine.deleteRoutine()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
}
