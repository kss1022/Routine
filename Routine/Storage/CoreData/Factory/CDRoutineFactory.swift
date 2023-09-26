//
//  CDRoutineFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



final class CDRoutineFactory: RoutineFactory{
    func create(routineId: RoutineId, routineName: RoutineName, routineDescription: RoutineDescription , icon: ImojiIcon, tint: Tint) -> Routine {
        Routine(routineId: routineId, routineName: routineName, routineDescription: routineDescription ,icon: icon, tint: tint)
    }
}
