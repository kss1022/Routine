//
//  RoutineDetailModel.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation



struct RoutineDetailModel{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let emojiIcon: String
    public let tint: String
    
    
    init(routineDetailDto: RoutineDetailDto) {
        self.routineId = routineDetailDto.routineId
        self.routineName = routineDetailDto.routineName
        self.routineDescription = routineDetailDto.routineDescription
        self.repeatType = routineDetailDto.repeatType
        self.repeatValue = routineDetailDto.repeatValue
        self.emojiIcon = routineDetailDto.emojiIcon
        self.tint = routineDetailDto.tint
    }
}
