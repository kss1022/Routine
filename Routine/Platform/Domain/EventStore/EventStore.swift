//
//  EventStore.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


/**
 *  EventStore
 *  이벤트 직렬화, 동시성 감지, 강한타입, AppendOnlyStore
 *
 *  AppendOnlyStore
 *  Fire-based Store , MS SQL Server Store
 *  MYSQL Store. Windows AzureBlob Store...
 */


protocol EventStore{
    func loadEventStrem(id : UUID) -> EventStream
    func loadEventStrem(id : UUID, version: Int) -> EventStream
    func loadEventStrem(id : UUID, skipCount: Int, maxCount: Int) -> EventStream
    func appendToStream(id : UUID, expectedVersion: Int , events : [DomainEvent]) throws
}

public class EventStoreImp : EventStore{
    
    private let appendOnlyStore : AppendOnlyStore
    
    init(appendOnlyStore: AppendOnlyStore) {
        self.appendOnlyStore = appendOnlyStore
    }
    
    func loadEventStrem(id: UUID) -> EventStream {
        let name = IdentityToString(id: id)
        let records =  appendOnlyStore.readRecord(
            name: name,
            afterVersion: nil,
            maxCounut: nil
        )
        
        let stream = EventStream()
        records.forEach { record in
            if let event = deserializeEvent(record.data){
                stream.events.append(event)
            }
        }
        
        
        if let lastVersion = records.last?.version{
            stream.version = lastVersion
        }
        
        return stream
    }
    
    func loadEventStrem(id: UUID, version: Int) -> EventStream {
        let name = IdentityToString(id: id)
        let records =  appendOnlyStore.readRecord(
            name: name,
            afterVersion: version,
            maxCounut: nil
        )
        
        let stream = EventStream()
        records.forEach { record in
            if let event = deserializeEvent(record.data){
                stream.events.append(event)
            }
        }
        
        if let lastVersion = records.last?.version{
            stream.version = lastVersion
        }
        
        return stream
    }
    
    func loadEventStrem(id: UUID, skipCount: Int, maxCount: Int) -> EventStream {
        let name = IdentityToString(id: id)
        let records = appendOnlyStore.readRecord(
            name: name,
            afterVersion: skipCount,
            maxCounut: maxCount
        )
        let stream = EventStream()
        
        records.forEach { record in
            if let event = deserializeEvent(record.data){
                stream.events.append(event)
                stream.version = record.version
            }
        }
        
        return stream
    }
    
    func appendToStream(id: UUID, expectedVersion: Int, events: [DomainEvent]) throws {
        if events.count == 0{ return }
        let name = IdentityToString(id: id)
        
        let datas = events.compactMap{ serializeEvent($0) }
        
        do{
            try appendOnlyStore.append(name: name, datas: datas, expectedVersion: expectedVersion)
            events.forEach {_ in
                //DomainEventPublihser.share.publish($0)
            }
        }catch DBError.AppendOnlyStoreConcurrency(let lastVersion,let expectedVersion,let name){
            Log.e("AppendOnlyStoreConcurrncy\nLastVersion:\(lastVersion)\nexpectedVersion:\(expectedVersion)\name:\(name)")
            throw DBError.ConcurrencyError(storeEvents: events, storeVersion: expectedVersion)
        }
    }
    
}


extension EventStore{
    
    fileprivate func IdentityToString(id : UUID) -> String{
        id.uuidString
    }
    
    fileprivate func serializeEvent(_ event: DomainEvent) -> Data?{ //-> Data?
        try! NSKeyedArchiver.archivedData(withRootObject: event, requiringSecureCoding: true)
    }
    
    
    fileprivate func deserializeEvent(_ data: Data) -> DomainEvent?{
        try! NSKeyedUnarchiver.unarchivedObject(ofClass: DomainEvent.self, from: data)
        //try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? DomainEvent
    }
}
