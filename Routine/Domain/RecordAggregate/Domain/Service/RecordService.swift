//
//  RecordService.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



final class RecordService{
    
    let eventStore: EventStore
    
    init(eventStore: EventStore) {
        self.eventStore = eventStore
    }
    
    
    public func exist(routineId: UUID) -> Bool{
        //TODO: Check Exist
        return false
    }
        
}
