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
            let routineId = RoutineId(id: UUID())
            let routineName = try RoutineName(command.name)
            
            let routine = routineFactory.create(routineId: routineId, routineName: routineName)
            
            try eventStore.appendToStream(id: routine.routinId.id, expectedVersion: -1, events: routine.changes)
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
    
}
