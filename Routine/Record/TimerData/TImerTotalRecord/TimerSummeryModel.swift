//
//  TimerSummeryModel.swift
//  Routine
//
//  Created by 한현규 on 1/23/24.
//

import Foundation



struct TimerSummeryModel{
    let totalDone: Int
    let totalTime: TimeInterval
    let topStreak: Int
    let currentStreak: Int
    
    init(totalDone: Int, totalTime: TimeInterval, topStreak: Int, currentStreak: Int) {
        self.totalDone = totalDone
        self.totalTime = totalTime
        self.topStreak = topStreak
        self.currentStreak = currentStreak
    }
}
