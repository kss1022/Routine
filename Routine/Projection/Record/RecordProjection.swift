//
//  RecordProjection.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation
import Combine


final class RecordProjection{
    
    
    private let recordDao: RecordDao
    
    private var cancellables: Set<AnyCancellable>

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        self.recordDao = dbManager.recordDao
        cancellables = .init()
        
        registerReceiver()
    }
    
    
    private func registerReceiver(){
        DomainEventPublihser.share
            .onReceive(RecordCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RecordCompleteSet.self, action: when)
            .store(in: &cancellables)
    }
    
    private func when(event: RecordCreated){
        do{
            let record = RecordDto(
                routineId: event.routineId.id,
                recordId: event.recordId.id,
                recordDate: Formatter.recordDate(year: event.recordDate.year, month: event.recordDate.month, day: event.recordDate.day),
                isComplete: event.isComplete,
                completedAt: event.occurredOn
            )
            try recordDao.save(record)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
    private func when(event: RecordCompleteSet){
        do{
            try recordDao.updateComplete(recordId: event.recordId.id, isComplete: event.isComplete, completeAt: event.occurredOn)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }


    
}

