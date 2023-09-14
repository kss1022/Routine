//
//  ConcurrencySafeEntity.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class ConcurrencySafeEntity : Entity{
        
    override init() {
        super.init()
    }
        
    public override func setConcurrencyVersion(concurrencyVersion: Int) {
        failWhenConcurrencyViolation(version: concurrencyVersion)
        self.concurrencyVersion = concurrencyVersion
    }
    
    public func failWhenConcurrencyViolation(version: Int){
        if version == self.concurrencyVersion{
            fatalError("Concurrency Violation: Stale data detected. Entity was already modified.")
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
