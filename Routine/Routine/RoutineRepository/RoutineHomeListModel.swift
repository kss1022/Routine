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
//    public let repeatType: RepeatTypeDto
//    public let repeatValue: RepeatValueDto
    public let emojiIcon: String
    public let tint: String
    public let sequence: Int
    public let recordId: UUID?
    //public let recordDate: Date
    public let isComplete: Bool
    
    init(listModel: RoutineListModel, set: Set<RoutineRecordDto>, recordDate: Date) {
        self.routineId = listModel.routineId
        self.routineName = listModel.routineName
        self.routineDescription = listModel.routineDescription
//        self.repeatType = routineListDto.repeatType
//        self.repeatValue = routineListDto.repeatValue
        self.emojiIcon = listModel.emojiIcon
        self.tint = listModel.tint
        self.sequence = Int(listModel.sequence)
        
        if let record =  set.first(where: { $0.routineId == listModel.routineId }){
            self.recordId = record.recordId
            self.isComplete = record.isComplete
        }else{
            self.recordId = nil
            self.isComplete = false
        }
        //self.recordDate = recordDate
    }
}

