//
//  CreateRoutineRecord.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



struct CreateRoutineRecord: Command{
    let routineId: UUID
    let date: Date
    let isComplete: Bool = true
}
