//
//  RoutineFactory.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



protocol RoutineFactory{
    func create( routineId: RoutineId, routineName: RoutineName, routineDescription: RoutineDescription, icon: ImojiIcon , tint: Tint) -> Routine
}
