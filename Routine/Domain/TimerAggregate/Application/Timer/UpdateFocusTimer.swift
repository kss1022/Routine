//
//  UpdateFocusTimer.swift
//  Routine
//
//  Created by 한현규 on 1/10/24.
//

import Foundation


struct UpdateFocusTimer: Command{
    let timerId: UUID
    let name: String
    let emoji: String
    let tint: String
    let min: Int
}
