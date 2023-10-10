//
//  RoutineRepeatDto.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//


import Foundation


public struct RepeatDto{
    let routineId: UUID
    let repeatType: RepeatTypeDto
    let repeatValue: RepeatValueDto
}

