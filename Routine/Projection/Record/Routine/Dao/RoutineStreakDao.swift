//
//  RoutineStreakDao.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation



protocol RoutineStreakDao{
    func save(_ dto: RoutineStreakDto) throws
    func topStreak(routineId: UUID) throws -> RoutineStreakDto?    
    func find(routineId: UUID , date: Date) throws -> RoutineStreakDto?
    func findCurrentStreak(routineId: UUID, date: Date) throws -> RoutineStreakDto?
    func complete(routineId: UUID, date: Date) throws
    func cancel(routineId: UUID, date: Date) throws
    func delete(routineId: UUID, date: Date) throws
}
