//
//  CreateTimer.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation




struct CreateSectionTimer: Command{
    let name: String
    let emoji: String
    let tint: String
    let timerType: String
    let createSections: [CreateSection]
}



struct CreateSection{
    let name: String
    let description: String
    let sequence: Int
    let type: String
    let min: Int?
    let sec: Int?
    let count: Int?
    let emoji: String
    let color: String
}
