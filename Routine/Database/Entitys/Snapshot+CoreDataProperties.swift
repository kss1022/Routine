//
//  Snapshot+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/15.
//
//

import Foundation
import CoreData


extension Snapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Snapshot> {
        return NSFetchRequest<Snapshot>(entityName: "Snapshot")
    }

    @NSManaged public var version: Int64
    @NSManaged public var data: Data?
    @NSManaged public var name: String?

}

extension Snapshot : Identifiable {

}
