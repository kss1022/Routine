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
    func updateDone(routineId: UUID, year: Int, weekOfYear: Int, dayOfWeek: Int, done: Bool) throws
}
