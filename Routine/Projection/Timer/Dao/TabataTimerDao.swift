//
//  TabataTimerDao.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation



protocol TabataTimerDao{
    func save(_ dto: TabataTimerDto) throws
    func update(_ dto: TabataTimerDto) throws
    func find(_ id: UUID) throws -> TabataTimerDto?
    func delete(_ id: UUID) throws
}
