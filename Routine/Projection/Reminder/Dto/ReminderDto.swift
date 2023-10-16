//
//  ReminderDto.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation



struct ReminderDto{
    let routineId: UUID
    let identifires: String
    let hour: Int
    let minute: Int
    
    init(routineId: UUID, identifiers: [String], hour: Int, minute: Int) {
        self.routineId = routineId
        self.identifires = identifiers.joined(separator: ",")
        self.hour = hour
        self.minute = minute
    }
    
    init(routineId: UUID, identifiers: String, hour: Int, minute: Int) {
        self.routineId = routineId
        self.identifires = identifiers
        self.hour = hour
        self.minute = minute
    }
    
    func getIdentifires() -> [String]{
        self.identifires.components(separatedBy: ",")
    }
}
