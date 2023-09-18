//
//  SnapshotModel+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//
//

import Foundation
import CoreData


extension SnapshotModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SnapshotModel> {
        return NSFetchRequest<SnapshotModel>(entityName: "SnapshotModel")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var version: Int64

}

extension SnapshotModel : Identifiable {

}
