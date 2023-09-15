//
//  EventSerializer.swift
//  Routine
//
//  Created by 한현규 on 2023/09/15.
//

import Foundation


enum SerializeError : Error{    
    case CastingError
}

final class EventSerializer{
    
    static func archiveData(_ event: DomainEvent) throws -> Data?{
        try NSKeyedArchiver.archivedData(withRootObject: event, requiringSecureCoding: true)
    }
 
    static func unarchivedEvent(_ data: Data) throws -> DomainEvent{
        let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [DomainEvent.self], from: data)
        if let event = object as? DomainEvent{
            return event
        }
        throw  SerializeError.CastingError
    }
}

final class EntitySerializer{
    
    static func archiveData(_ event: Entity) throws -> Data?{
        try NSKeyedArchiver.archivedData(withRootObject: event, requiringSecureCoding: true)
    }
 
    static func unarchivedEvent(_ data: Data) throws -> Entity{
        let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [Entity.self], from: data)
        if let event = object as? Entity{
            return event
        }
        throw  SerializeError.CastingError
    }
}

