//
//  SnapshotEntity+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/19.
//
//

import Foundation
import CoreData


extension SnapshotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SnapshotEntity> {
        return NSFetchRequest<SnapshotEntity>(entityName: "SnapshotEntity")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var version: Int64

}

extension SnapshotEntity : Identifiable {

}
