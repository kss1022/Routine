//
//  ApplicationService.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



protocol ApplicationService{
    var eventStore : EventStore{ get }
    var snapshotRepository: SnapshotRepository{ get }
}


extension ApplicationService{
    
    func update<T>(id: UUID, excute : (T) -> ()) throws where T : Entity{
        while true{
            let snapshot : (T, EventStream) = try loadEntityById(id)
            let entity = snapshot.0
            let eventStream = snapshot.1
            excute(entity)
            do{
                try eventStore.appendToStream(id: id, expectedVersion: eventStream.version, events: entity.changes)
                
                if eventStream.events.count > 3{
                    try snapshotRepository.saveSanpshot(id: id, entity: entity, version: eventStream.version)
                }
                return
            }catch ConcurrencyError.ConcurrencyError(let events , let version){
                for failedEvent in entity.changes{
                    for succeedEvent in events{
                        if conflictWith(event1: failedEvent, event2: succeedEvent){
                            let msg = "Conflit Betewwn \(failedEvent) \(succeedEvent)"
                            Log.e(msg)
                            throw ConcurrencyError.RealConcurrencyException(
                                msg: msg,
                                concurrencyError: ConcurrencyError.ConcurrencyError(storeEvents: events, storeVersion: version)
                            )
                        }
                    }
                }
                try? eventStore.appendToStream(id: id, expectedVersion: version, events: entity.changes)
            }
        }
    }
    
    func update<T>(id: UUID, excute : (T) throws -> ()) throws where T : Entity{
        while true{
            let snapshot : (T, EventStream) = try loadEntityById(id)
            let entity = snapshot.0
            let eventStream = snapshot.1
            try excute(entity)
            do{
                try eventStore.appendToStream(id: id, expectedVersion: eventStream.version, events: entity.changes)
                
                if eventStream.events.count > 3{
                    try snapshotRepository.saveSanpshot(id: id, entity: entity, version: eventStream.version)
                }
                return
            }catch ConcurrencyError.ConcurrencyError(let events , let version){
                for failedEvent in entity.changes{
                    for succeedEvent in events{
                        if conflictWith(event1: failedEvent, event2: succeedEvent){
                            let msg = "Conflit Betewwn \(failedEvent) \(succeedEvent)"
                            Log.e(msg)
                            throw ConcurrencyError.RealConcurrencyException(
                                msg: msg,
                                concurrencyError: ConcurrencyError.ConcurrencyError(storeEvents: events, storeVersion: version)
                            )
                        }
                    }
                }
                try? eventStore.appendToStream(id: id, expectedVersion: version, events: entity.changes)
            }
        }
    }
    
    
    private func loadEntityById<T>(_ id: UUID) throws -> (T, EventStream) where T : Entity{
        var entity: T?
        var snapshotVersion = 1
            if try snapshotRepository.tryGetSnapshotById(id: id, entity: &entity, version: &snapshotVersion), let entity = entity{
            let eventStream = try eventStore.loadEventStrem(id: id, version: snapshotVersion)
            entity.replayEvent(eventStream.events)
            return (entity, eventStream)
        }

        let eventStream = try eventStore.loadEventStrem(id: id)
        entity = T.init(eventStream.events)
        return (entity!, eventStream)
    }

        
    private func conflictWith(event1 : Event , event2: Event) -> Bool{
        type(of: event1) == type(of: event2)
    }

}
