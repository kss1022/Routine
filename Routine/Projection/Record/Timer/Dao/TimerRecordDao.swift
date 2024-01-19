//
//  TimerRecordDao.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol TimerRecordDao{
    func save(_ dto: TimerRecordDto) throws
    func findAll(timerId: UUID, date: String) throws -> [TimerRecordDto]
    func findAll(_ date: String) throws -> [TimerRecordDto]
    func findAll(_ timerId: UUID) throws -> [TimerRecordDto]
}

