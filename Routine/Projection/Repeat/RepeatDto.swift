//
//  RoutineRepeatDto.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//


import Foundation


public struct RepeatDto{
    public let routineId: UUID
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
}

