//
//  TimerCountdownDao.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



protocol TimerCountdownDao{
    func save(_ dto: TimerCountdownDto) throws
    func update(_ dto: TimerCountdownDto) throws
    func find(_ id: UUID) throws -> TimerCountdownDto?
    func delete(_ id: UUID) throws
}
