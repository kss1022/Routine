//
//  TimerMonthRecordDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation



protocol TimerMonthRecordDao{
    func update(timerId: UUID, month: String, time: TimeInterval) throws
    func find(timerId: UUID, month: String) throws -> TimerMonthRecordDto?
}
