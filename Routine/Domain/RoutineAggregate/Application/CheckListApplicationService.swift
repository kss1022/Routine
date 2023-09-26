//
//  CheckListApplicationService.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



final class CheckListApplicationService: ApplicationService{
    
    var eventStore: EventStore
    var snapshotRepository: SnapshotRepository
    
    private let checkListFactory: CheckListFactory
    
    
    init(eventStore: EventStore, snapshotRepository: SnapshotRepository, checkListFactory: CheckListFactory) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.checkListFactory = checkListFactory
    }
    
    func when(_ command: CreateCheckList) async throws{
        do{
            if command.routineId == nil{
                throw ArgumentException("Create CheckList Error : RoutineId is nil")
            }
            
            let routineId = RoutineId(command.routineId!)
            let checkListId =  CheckListId(UUID())
            let checkListName = try CheckListName(command.name)
            let reps = Repetition(command.reps)
            let set = SetCount(command.set)
            let weight = Weight(command.weight)
            
            let checkList = checkListFactory.create(
                routineId: routineId,
                checkListId: checkListId,
                checkListName: checkListName,
                reps: reps,
                set: set,
                weight: weight
            )

            try eventStore.appendToStream(id: checkList.checkListId.id, expectedVersion: -1, events: checkList.changes)
            try Transaction.commit()
        }catch{
            try Transaction.commit()
            throw error
        }
    }
}
