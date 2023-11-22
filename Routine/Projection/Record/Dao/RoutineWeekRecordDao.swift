//
//  RoutineWeekRecordDao.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation


protocol RoutineWeekRecordDao{
    func save(_ dto: RoutineWeekRecordDto) throws
    func find(routineId: UUID, startOfWeek: String , endOfWeek: String) throws -> RoutineWeekRecordDto?
    func findAll() throws -> [RoutineWeekRecordDto]
    func complete(dto: RoutineWeekRecordDto, dayOfWeek: Int) throws
    func cancel(dto: RoutineWeekRecordDto, dayOfWeek: Int) throws
}
