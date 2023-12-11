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
    func loadEventStrem(id : UUID) throws -> EventStream
    func loadEventStrem(id : UUID, version: Int) throws -> EventStream
    func loadEventStrem(id : UUID, skipCount: Int, maxCount: Int) throws -> EventStream
    func appendToStream(id : UUID, expectedVersion: Int , events : [Event]) throws
}


public final class EventStoreImp : EventStore{
    
    private let appendOnlyStore : AppendOnlyStore
    
    init(appendOnlyStore: AppendOnlyStore) {
        self.appendOnlyStore = appendOnlyStore
    }
    
    func loadEventStrem(id: UUID) throws -> EventStream {
        let name = IdentityToString(id)
        let records =  try appendOnlyStore.readRecord(
            name: name,
            afterVersion: nil,
            maxCounut: nil
        )
        
        let stream = EventStream()
        
        try records.forEach { record in
            let event = try EventSerializer.unarchivedEvent(record.data)
            stream.events.append(event)
        }
        
        
        if let lastVersion = records.last?.version{
            stream.version = lastVersion
        }
        
        return stream
    }
    
    func loadEventStrem(id: UUID, version: Int) throws -> EventStream {
        let name = IdentityToString(id)
        let records = try appendOnlyStore.readRecord(
            name: name,
            afterVersion: version,
            maxCounut: nil
        )
        
        let stream = EventStream()
        try records.forEach { record in
            let event = try EventSerializer.unarchivedEvent(record.data)
            stream.events.append(event)
        }
        
        if let lastVersion = records.last?.version{
            stream.version = lastVersion
        }
        
        return stream
    }
    
    func loadEventStrem(id: UUID, skipCount: Int, maxCount: Int) throws -> EventStream {
        let name = IdentityToString(id)
        let records = try appendOnlyStore.readRecord(
            name: name,
            afterVersion: skipCount,
            maxCounut: maxCount
        )
        let stream = EventStream()
        
        try records.forEach { record in
            let event = try EventSerializer.unarchivedEvent(record.data)
            stream.events.append(event)
            stream.version = record.version
        }
        
        return stream
    }
    
    func appendToStream(id: UUID, expectedVersion: Int, events: [Event]) throws {
        if events.count == 0{ return }
        let name = IdentityToString(id)
        
        let datas = try events.compactMap{ try EventSerializer.archiveData($0)}
        
        do{
            try appendOnlyStore.append(name: name, datas: datas, expectedVersion: expectedVersion)
            events.forEach { event in
                DomainEventPublihser.shared.publish(event)            
            }
        }catch ConcurrencyError.AppendOnlyStoreConcurrency(let lastVersion,let expectedVersion,let name){
            Log.e("AppendOnlyStoreConcurrncy\nLastVersion:\(lastVersion)\nexpectedVersion:\(expectedVersion)\name:\(name)")
            throw ConcurrencyError.ConcurrencyError(storeEvents: events, storeVersion: expectedVersion)
        }
    }

}


private extension EventStoreImp{
    private func IdentityToString(_ id : UUID) -> String{
        id.uuidString
    }
}
