//
//  EventModel+CoreDataProperties.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//
//

import Foundation
import CoreData


extension EventModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventModel> {
        return NSFetchRequest<EventModel>(entityName: "EventModel")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var version: Int64

}

extension EventModel : Identifiable {

}
