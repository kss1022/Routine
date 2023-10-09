//
//  UpdateRoutine.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation



struct UpdateRoutine: Command{
    let routineId: UUID
    let name: String
    let description: String
    let emoji: String
    let tint: String
}
