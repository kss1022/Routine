//
//  Entity.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class Entity : NSObject, NSCoding{

    public var concurrencyVersion : Int!
    
    public override init() {
        super.init()
        setConcurrencyVersion(concurrencyVersion: 0)
    }
    
    public func setConcurrencyVersion(concurrencyVersion: Int){
        self.concurrencyVersion = concurrencyVersion
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(concurrencyVersion , forKey: "concurrencyVersion")
        
    }
    
    public required init?(coder: NSCoder) {
        self.concurrencyVersion = coder.decodeInteger(forKey: "concurrencyVersion")
    }
    
    
}

