//
//  CDRoutineFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



final class CDRoutineFactory: RoutineFactory{
    func create(routineId: RoutineId, routineName: RoutineName, routineDescription: RoutineDescription, repeat: Repeat, reminder: Reminder?, icon: Emoji, tint: Tint) -> Routine {
        Routine(routineId: routineId, routineName: routineName, routineDescription: routineDescription, repeat: `repeat`, reminder: reminder ,icon: icon, tint: tint)
    }
}
