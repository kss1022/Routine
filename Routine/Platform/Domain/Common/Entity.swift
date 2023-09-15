//
//  Entity.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class Entity : NSObject{

    public var concurrencyVersion : Int!
    
    public override init() {
        super.init()
        setConcurrencyVersion(concurrencyVersion: 0)
    }
    
    public func setConcurrencyVersion(concurrencyVersion: Int) {
        failWhenConcurrencyViolation(version: concurrencyVersion)
        self.concurrencyVersion = concurrencyVersion
    }
    
    public func failWhenConcurrencyViolation(version: Int){
        if version == self.concurrencyVersion{
            fatalError("Concurrency Violation: Stale data detected. Entity was already modified.")
        }
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(concurrencyVersion, forKey: "concurrencyVersion")
    }
    
    public init?(coder: NSCoder) {
        self.concurrencyVersion = coder.decodeInteger(forKey: "concurrencyVersion")
    }
    
}


typealias AbstractEntity = Entity & NSCoding & NSSecureCoding
