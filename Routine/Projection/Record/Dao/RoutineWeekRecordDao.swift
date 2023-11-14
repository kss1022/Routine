//
//  RoutineWeekRecordDao.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation


protocol RoutineWeekRecordDao{
    func save(_ dto: RoutineWeekRecordDto) throws
    func find(routineId: UUID, year: Int, weekOfYear: Int) throws -> RoutineWeekRecordDto?
    func complete(routineId: UUID, year: Int, weekOfYear: Int, dayOfWeek: Int) throws
    func cancel(routineId: UUID, year: Int, weekOfYear: Int, dayOfWeek: Int) throws
}
