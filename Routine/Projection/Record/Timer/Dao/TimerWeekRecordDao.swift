//
//  TimerWeekRecordDto.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation




protocol TimerWeekRecordDao{
    func find(timerId: UUID, startOfWeek: String , endOfWeek: String) throws -> TimerWeekRecordDto?
    func update(timerId: UUID, startOfWeek: String , endOfWeek: String, dayOfWeek: Int, time: TimeInterval) throws
}
