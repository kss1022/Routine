//
//  SetCompleteTimerRecord.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



struct SetCompleteTimerRecord: Command{
    let recordId: UUID
    let endAt: Date
    let duration: Double
}
