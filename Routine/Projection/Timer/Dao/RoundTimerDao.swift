//
//  RoundTimerDao.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation



protocol RoundTimerDao{
    func save(_ dto: RoundTimerDto) throws
    func update(_ dto: RoundTimerDto) throws
    func find(_ id: UUID) throws -> RoundTimerDto?
    func delete(_ id: UUID) throws
}
