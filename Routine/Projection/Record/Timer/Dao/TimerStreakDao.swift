//
//  TimerStreakDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation



protocol TimerStreakDao{
    func find(timerId: UUID , date: String) throws -> TimerStreakDto?
    func findTopStreak(timerId: UUID) throws -> TimerStreakDto?
    func findCurrentStreak(timerId: UUID, date: String) throws -> TimerStreakDto?
    func update(timerId: UUID , today: String, yesterday: String) throws
}
