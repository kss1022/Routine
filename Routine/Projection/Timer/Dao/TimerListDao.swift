//
//  TimerListDao.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation


protocol TimerListDao{
    func save(_ dto: TimerListDto) throws
    func update(_ dto: TimerListDto) throws
    func find(_ id: UUID) throws -> TimerListDto?
    func findAll() throws -> [TimerListDto]
    func delete(_ id: UUID) throws
}
