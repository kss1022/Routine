//
//  Entity.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class Entity : NSObject{

    public var concurrencyVersion : Int!
    public var changes : [Event]

    public override init() {
        changes = []
        self.concurrencyVersion = 0
        super.init()
    }
    
    
    public required init(_ events : [Event]){
        self.changes = []
        self.concurrencyVersion = 0
        super.init()
        self.replayEvent(events)
    }
    
    //ReconstructEntity
    public func replayEvent(_ events : [Event]){
        events.forEach {
            mutate($0)
        }
    }
        
    //HandleNewEvent
    public func apply(_ event : Event){
        changes.append(event)
        mutate(event)
    }
    
    
    public func mutate(_ event: Event){
        
    }
    
    public func setConcurrencyVersion(concurrencyVersion: Int) {
        failWhenConcurrencyViolation(version: concurrencyVersion)
        self.concurrencyVersion = concurrencyVersion
    }
    
    public func failWhenConcurrencyViolation(version: Int){
        if version != self.concurrencyVersion{
            fatalError("Concurrency Violation: Stale data detected. Entity was already modified.")
        }
    }
    
    public func encode(with coder: NSCoder) {        
        coder.encodeInteger(concurrencyVersion, forKey: "concurrencyVersion")
    }
    
    public init?(coder: NSCoder) {
        self.changes = []
        self.concurrencyVersion = coder.decodeInteger(forKey: "concurrencyVersion")
        super.init()
    }
    
}
 

public typealias DomainEntity = Entity & NSCoding & NSSecureCoding

