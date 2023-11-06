//
//  RoutineRecordDto.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


public struct RoutineRecordDto{
    public let routineId: UUID
    public let recordId: UUID
    public let recordDate: String
    public let isComplete: Bool
    public let completedAt: Date
}
