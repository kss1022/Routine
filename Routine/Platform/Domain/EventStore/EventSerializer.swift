//
//  EventSerializer.swift
//  Routine
//
//  Created by 한현규 on 2023/09/15.
//

import Foundation


enum EventSerializerError : Error{
    
    case CastingError
}

class EventSerializer{
    
    static func archiveData(_ event: DomainEvent) throws -> Data?{
        try NSKeyedArchiver.archivedData(withRootObject: event, requiringSecureCoding: true)
    }
 
    static func unarchivedEvent(_ data: Data) throws -> DomainEvent{
        let object = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [DomainEvent.self], from: data)
        if let event = object as? DomainEvent{
            return event
        }
        throw  EventSerializerError.CastingError
    }
}
