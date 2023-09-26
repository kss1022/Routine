//
//  RenameRoutine.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation




struct ChangeRoutineName: Command{
    let routineId: UUID
    let routineName: String
}
