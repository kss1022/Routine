//
//  CheckListCreated.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



final class CheckListCreated: DomainEvent{
    let routineId: RoutineId
    let checkListId: CheckListId
    let checkListName: CheckListName
    let reps: Repetition
    let set: SetCount
    let weight: Weight
    
    init(routineId: RoutineId!, checkListId: CheckListId!, checkListName: CheckListName!, reps: Repetition, set: SetCount, weight: Weight) {
        self.routineId = routineId
        self.checkListId = checkListId
        self.checkListName = checkListName
        self.reps = reps
        self.set = set
        self.weight = weight
        super.init()
    }
    
    
    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        checkListId.encode(with: coder)
        checkListName.encode(with: coder)
        reps.encode(with: coder)
        set.encode(with: coder)
        weight.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let checkListId = CheckListId(coder: coder),
              let checkListName = CheckListName(coder: coder),
              let reps = Repetition(coder: coder),
              let set = SetCount(coder: coder),
              let weight = Weight(coder: coder)
        else { return nil }

        
        self.routineId = routineId
        self.checkListId = checkListId
        self.checkListName = checkListName
        self.reps = reps
        self.set = set
        self.weight = weight
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}
