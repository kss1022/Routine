//
//  ReminderDao.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation



protocol ReminderDao{
    func save(_ dto: ReminderDto) throws
    func update(_ dto: ReminderDto) throws
    func find(id: UUID) throws -> ReminderDto?
    func findAll() throws -> [ReminderDto]
    func delete(id: UUID) throws
}
