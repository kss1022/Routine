//
//  RoutineListModel.swift
//  Routine
//
//  Created by 한현규 on 12/7/23.
//

import Foundation

//TODO: dto -> model

struct RoutineListModel{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let emojiIcon: String
    public let tint: String
    public let sequence: Int
    
    init(_ dto: RoutineListDto) {
        self.routineId = dto.routineId
        self.routineName = dto.routineName
        self.routineDescription = dto.routineDescription
        self.repeatType = dto.repeatType
        self.repeatValue = dto.repeatValue
        self.emojiIcon = dto.emojiIcon
        self.tint = dto.tint
        self.sequence = Int(dto.sequence)
    }
}
