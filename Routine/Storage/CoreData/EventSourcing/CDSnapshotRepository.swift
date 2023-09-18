//
//  CDSnapshotRepository.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import CoreData



public class CDSnapshotRepository : SnapshotRepository{
    
    public func tryGetSnapshotById<T>(id: UUID, entity: inout T?, version: inout Int) throws -> Bool where T : Entity {
        let context = try NSManagedObjectContext.mainContext()
        let name = IdentityToString(id)
        
        let request = NSFetchRequest<SnapshotModel>(entityName: SnapshotModel.entityName)
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(SnapshotModel.name), name)
        request.fetchLimit = 1
        if let snapshot = context.query(request).first{
            let decode = try EntitySerializer.unarchivedEvent(snapshot.data!) as? T
            if decode != nil{
                entity = decode
                version = Int(snapshot.version)
                return true
            }
        }
        return false
    }
    
    public func saveSanpshot(id: UUID, entity: Entity, version: Int) throws{
        let context = try Transaction.context()
        let name = IdentityToString(id)
        
        let data = try EntitySerializer.archiveData(entity)
        
        let snapshot = SnapshotModel(context: context)
        snapshot.data = data
        snapshot.version = Int64(version)
        snapshot.name = name
    }

}


private extension CDSnapshotRepository{
    
    private func IdentityToString(_ id : UUID) -> String{
        id.uuidString
    }
}
