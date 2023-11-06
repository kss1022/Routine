//
//  RoutineRecordDao.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



protocol RoutineRecordDao{
    func save(_ dto: RoutineRecordDto) throws
    func updateComplete(recordId: UUID, isComplete: Bool, completeAt: Date) throws
    func find(routineId: UUID, date: String) throws -> RoutineRecordDto?
    func findAll(_ date: String) throws -> [RoutineRecordDto]
    func findAll(_ routindId: UUID) throws -> [RoutineRecordDto]
}
