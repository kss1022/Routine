//
//  EventSourcingError.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation



indirect enum ConcurrencyError : Error{
    case ConcurrencyError(storeEvents: [Event], storeVersion : Int)
    case RealConcurrencyException( msg : String, concurrencyError : ConcurrencyError)
    case AppendOnlyStoreConcurrency( version: Int, expectedVersion: Int, name: String)
}
