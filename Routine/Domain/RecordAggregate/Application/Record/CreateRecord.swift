//
//  CreateRecord.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



struct CreateRecord: Command{
    let routineId: UUID
    let date: Date
    let isComplete: Bool = true
}
