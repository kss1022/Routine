//
//  SetCompleteRecord.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation




struct SetCompleteRoutineRecord: Command{
    let recordId: UUID
    let isComplete: Bool
}
