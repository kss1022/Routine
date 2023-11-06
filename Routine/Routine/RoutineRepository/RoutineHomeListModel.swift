//
//  RoutineHomeListModel.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


public struct RoutineHomeListModel{
    public let routineId: UUID
    public let routineName: String
    public let routineDescription: String
    public let repeatType: RepeatTypeDto
    public let repeatValue: RepeatValueDto
    public let emojiIcon: String
    public let tint: String
    public let sequence: Int
    public let recordId: UUID?
    //public let recordDate: Date
    public let isComplete: Bool
    
    init(routineListDto: RoutineListDto, set: Set<RoutineRecordDto>, recordDate: Date) {
        self.routineId = routineListDto.routineId
        self.routineName = routineListDto.routineName
        self.routineDescription = routineListDto.routineDescription
        self.repeatType = routineListDto.repeatType
        self.repeatValue = routineListDto.repeatValue
        self.emojiIcon = routineListDto.emojiIcon
        self.tint = routineListDto.tint
        self.sequence = Int(routineListDto.sequence)
        
        if let record =  set.first(where: { $0.routineId == routineListDto.routineId }){
            self.recordId = record.recordId
            self.isComplete = record.isComplete
        }else{
            self.recordId = nil
            self.isComplete = false
        }
        //self.recordDate = recordDate
    }
}

