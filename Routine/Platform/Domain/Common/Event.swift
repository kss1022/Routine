//
//  DomainEvent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class Event: NSObject{
    
    public var eventVersion: Int
    public var occurredOn: Date

    public override init(){
        self.eventVersion = -1
        self.occurredOn = Date()
        super.init()
    }
        

    public func encode(with coder: NSCoder) {
        coder.encode(eventVersion, forKey: "eventVersion")
        coder.encode(occurredOn as NSDate, forKey: "occuredOn")
    }
    
    public init?(coder: NSCoder) {
        self.eventVersion = coder.decodeInteger(forKey: "eventVersion")
        self.occurredOn = coder.decodeObject(of: NSDate.self, forKey: "occuredOn")! as Date
    }
}

typealias DomainEvent = Event & NSCoding & NSSecureCoding
