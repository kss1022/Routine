//
//  EventEntity+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/19.
//
//

import Foundation
import CoreData


extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var version: Int64

}

extension EventEntity : Identifiable {

}
