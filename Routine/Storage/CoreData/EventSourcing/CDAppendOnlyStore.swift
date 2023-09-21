//
//  CDAppendOnlyStore.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import CoreData



public final class CDAppendOnlyStore : AppendOnlyStore{
    
    func append(name: String, data: Data, expectedVersion: Int) throws {
        let context = try Transaction.context()
        
        let lastVersion = try lastVersion(name: name)
        if expectedVersion != -1{
            if lastVersion != expectedVersion{
                throw ConcurrencyError.AppendOnlyStoreConcurrency(version: lastVersion, expectedVersion: expectedVersion, name: name)
            }
        }

        let event = EventEntity(context: context)
        event.data = data
        event.name = name
        event.version = Int64(expectedVersion + 1)
    }
    
    func append(name: String, datas: [Data], expectedVersion: Int) throws {
        let context = try Transaction.context()
        
        let lastVersion = try lastVersion(name: name)
        if expectedVersion != -1{
            if lastVersion != expectedVersion{
                throw ConcurrencyError.AppendOnlyStoreConcurrency(version: lastVersion, expectedVersion: expectedVersion, name: name)
            }
        }
        
        for i in 0..<datas.count{
            let event = EventEntity(context: context)
            event.data = datas[i]
            event.name = name
            event.version = Int64(expectedVersion + i + 1)
        }
    }
    
    func readRecord(name: String, afterVersion: Int?, maxCounut: Int?) throws -> [DataWithVersion] {
        try findEvents(name: name, afterVersion: afterVersion, maxCount: maxCounut).map(DataWithVersion.init)
    }
    
    func readRecord(afterVersion: Int?, maxCount: Int?) throws -> [DataWithName] {
        let events = try findEvents(afterVersion: afterVersion, maxCount: maxCount)
        return Dictionary(grouping: events) { $0.name }
            .map { (key, data) in
                DataWithName(name: key!, data: data.compactMap{ $0.data })
        }
    }
    
    func close() {
        
    }
      
}


private extension CDAppendOnlyStore{
    private func findEvents(name: String? = nil, afterVersion: Int? = nil, maxCount: Int? = nil)  throws -> [EventEntity]{
        let context = try NSManagedObjectContext.mainContext()
        
        let request = NSFetchRequest<EventEntity>(entityName: EventEntity.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(EventEntity.version), ascending: true)]
        
        var predicates = [NSPredicate]()
        
        //set filterBy Name
        if name != nil{
            predicates.append(
                NSPredicate(format: "%K == %@",#keyPath(EventEntity.name), name!)
            )
        }
        
        //set filterBy after Version
        if afterVersion != nil{
            predicates.append(
                NSPredicate(format: "%K > %@",#keyPath(EventEntity.version), NSNumber(integerLiteral: afterVersion!))
            )
        }
            
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)

        //set MaxCount
        if maxCount != nil{
            request.fetchLimit = maxCount!
        }


        return context.query(request)
    }
    
    private func lastVersion(name: String) throws -> Int{
        let context = try NSManagedObjectContext.mainContext()
        
        let request = NSFetchRequest<NSDictionary>(entityName: EventEntity.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(EventEntity.version), ascending: false)]
        request.predicate =  NSPredicate(format: "%K == %@",#keyPath(EventEntity.name), name)
        request.propertiesToFetch = ["version"]
        request.resultType = .dictionaryResultType
        request.fetchLimit = 1
        return context.query(request).first?["version"] as? Int ?? -1
    }
    
}
