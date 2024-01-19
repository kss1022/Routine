//
//  CreateTimerRecord.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



struct CreateTimerRecord: Command{
    let timerId: UUID    
    let startAt: Date
    let endAt: Date
    let recordDate: Date
    let duration: Double
}
