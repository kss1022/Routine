//
//  Event+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var version: Int64

}

extension Event : Identifiable {

}
