//
//  DBError.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation



indirect enum DBError : Error{
    
    case ConcurrencyError(storeEvents: [DomainEvent], storeVersion : Int)
    case RealConcurrencyException( msg : String, concurrencyError : DBError)
    case AppendOnlyStoreConcurrency( version: Int, expectedVersion: Int, name: String)
        
    case CoreDataError(reason: String)
}
