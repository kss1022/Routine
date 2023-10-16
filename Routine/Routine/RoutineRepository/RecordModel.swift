//
//  RecordModel.swift
//  Routine
//
//  Created by 한현규 on 10/16/23.
//

import Foundation



struct RecordModel{
    public let routineId: UUID
    public let recordId: UUID
    public let recordDate: String
    public let isComplete: Bool
    public let completedAt: Date
    
    init(_ recordDto: RecordDto) {
        self.routineId = recordDto.routineId
        self.recordId = recordDto.recordId
        self.recordDate = recordDto.recordDate
        self.isComplete = recordDto.isComplete
        self.completedAt = recordDto.completedAt
    }
}
