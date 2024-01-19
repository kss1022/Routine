//
//  TimerTotalRecordDao.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//

import Foundation



protocol TimerTotalRecordDao{
    func find(timerId: UUID) throws -> TimerTotalRecordDto?
    func update(timerId: UUID, time: TimeInterval) throws
}

