//
//  RoutineMonthRecordDao.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




protocol RoutineMonthRecordDao{
    func save(_ dto: RoutineMonthRecordDto) throws
    func find(routineId: UUID, recordMonth: String) throws -> RoutineMonthRecordDto?
    
    func updateDone(routineId: UUID, recordMonth: String, increment: Int) throws
}
