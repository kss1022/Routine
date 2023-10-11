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
    
    private let checkListFactory: CheckListFactory
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        routineFactory: RoutineFactory,
        routineService: RoutineService,
        checkListFactory: CheckListFactory
    ) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.routineFactory = routineFactory
        self.routineService = routineService
        self.checkListFactory = checkListFactory
    }
    
    
    
    func when(_ command: CreateRoutine) async throws{
        do{
            Log.v("When (\(CreateRoutine.self)):  \(command)")
            
            let routineId = RoutineId(UUID())
            let routineName = try RoutineName(command.name)
            let routineDescription = try RoutineDescription(description: command.description)
            let `repeat` = try Repeat(repeatType: command.repeatType, data: command.repeatValue)
            let icon = Emoji(command.emoji)
            let tint = Tint(command.tint)
                                                
            let routine = routineFactory.create(routineId: routineId, routineName: routineName, routineDescription: routineDescription, repeat: `repeat`, icon: icon, tint: tint)
            
            
                        
            let checkLists = try command.createCheckLists.map { createCheckList in
                let checkListId =  CheckListId(UUID())
                let checkListName = try CheckListName(createCheckList.name)
                let reps = Repetition(createCheckList.reps)
                let set = SetCount(createCheckList.set)
                let weight = Weight(createCheckList.weight)
                
                return checkListFactory.create(
                    routineId: routineId,
                    checkListId: checkListId,
                    checkListName: checkListName,
                    reps: reps,
                    set: set,
                    weight: weight
                )
            }
            
            try checkLists.forEach { checkList in
                try eventStore.appendToStream(id: checkList.checkListId.id, expectedVersion: -1, events: checkList.changes)
            }
            
            
            try eventStore.appendToStream(id: routine.routineId.id, expectedVersion: -1, events: routine.changes)
            try Transaction.commit()
            
            
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateRoutine) async throws{
        do{
            let routineId = RoutineId(UUID())
            let routineName = try RoutineName(command.name)
            let routineDescription = try RoutineDescription(description: command.description)
            let `repeat` = try Repeat(repeatType: command.repeatType, data: command.repeatValue)
            let icon = Emoji(command.emoji)
            let tint = Tint(command.tint)
         
            try update(id: command.routineId) { (routine: Routine) in
                routine.updateRoutine(
                    routineName,
                    routineDescription: routineDescription, 
                    repeat: `repeat`,
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
