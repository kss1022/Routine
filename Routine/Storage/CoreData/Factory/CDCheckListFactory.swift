//
//  CDCheckListFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



final class CDCheckListFactory : CheckListFactory{
    func create(routineId: RoutineId, checkListId: CheckListId, checkListName: CheckListName, reps: Repetition, set: SetCount, weight: Weight) -> CheckList {
        CheckList(
            routineId: routineId,
            checkListId: checkListId,
            checkListName: checkListName,
            reps: reps,
            set: set,
            weight: weight
        )
    }
    
}
