//
//  UpdateSectionTimer.swift
//  Routine
//
//  Created by 한현규 on 1/10/24.
//

import Foundation



struct UpdateSectionTimer: Command{
    let timerId: UUID
    let name: String
    let emoji: String
    let tint: String
    let updateSections: [UpdateSection]
}


struct UpdateSection{
    let name: String
    let description: String
    let sequence: Int
    let type: String
    let min: Int?
    let sec: Int?
    let count: Int?
    let emoji: String
    let color: String?
}
