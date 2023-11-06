//
//  RecorddRepository.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol RecordRepository{
    
}


final class RecordRepositoryImp: RecordRepository{
    
    
    func fetchTimerRecordLists() async throws {
        let records = try timerRecordReadModel.records(date: Date())
        Log.v("Fetch RecordList: \(records)")
    }
    
    private let timerRecordReadModel: TimerRecordReadModelFacade
    
    init(timerRecordReadModel: TimerRecordReadModelFacade) {
        self.timerRecordReadModel = timerRecordReadModel
        
        Task{
            try? await fetchTimerRecordLists()
        }
        
    }
    
}
