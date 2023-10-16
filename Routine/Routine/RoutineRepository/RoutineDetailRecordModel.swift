//
//  RoutineRecordModel.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation



struct RoutineDetailRecordModel{    
    public let recordId: UUID?
    public let recordDate: Date
    public let isComplete: Bool
    public let recordModels: [RecordModel]
    
    
    init(recordDto: RecordDto?, recordDate: Date ,recordDtos: [RecordDto]) {
        if recordDto == nil{
            self.recordId = nil
            self.isComplete = false
        }else{
            self.recordId = recordDto!.recordId
            self.isComplete = recordDto!.isComplete
        }
        
        self.recordDate = recordDate
        self.recordModels = recordDtos.map(RecordModel.init)
    }
}



