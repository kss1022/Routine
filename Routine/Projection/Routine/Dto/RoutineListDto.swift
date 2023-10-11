//
//  RoutineListDto.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



public struct RoutineListDto{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let emojiIcon: String
    public let tint: String
    public let sequence: Int64
    
//    public let repeatType: String
//    public let repeatValue: Data
}
