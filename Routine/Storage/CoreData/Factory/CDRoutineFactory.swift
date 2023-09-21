//
//  CDRoutineFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



final class CDRoutineFactory: RoutineFactory{
    func create(
        routineId: RoutineId,
        routineName: RoutineName
    ) -> Routine {
        Routine(routineId: routineId, name: routineName)
    }
}
