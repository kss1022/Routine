//
//  CheckListFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation




protocol CheckListFactory{
    func create(routineId: RoutineId, checkListId: CheckListId, checkListName: CheckListName, reps: Repetition, set: SetCount, weight: Weight) -> CheckList
}
