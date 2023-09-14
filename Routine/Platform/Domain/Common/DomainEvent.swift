//
//  DomainEvent.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class DomainEvent : NSObject, NSCoding{
            
    var eventVersion: Int
    var occuredOn: Date
    
    init(eventVersion: Int) {
        self.eventVersion = eventVersion
        self.occuredOn = Date()
    }
    
    override init() {
        self.eventVersion = -1
        self.occuredOn = Date()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(eventVersion, forKey: "eventVersion")
        coder.encode(occuredOn as NSDate, forKey: "occuredOn")
    }
    
    public required init?(coder: NSCoder) {
        self.eventVersion = coder.decodeInteger(forKey: "eventVersion")
        self.occuredOn = coder.decodeObject(of: NSDate.self, forKey: "occuredOn")! as Date
    }
    

}
