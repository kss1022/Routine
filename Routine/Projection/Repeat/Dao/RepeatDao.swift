//
//  RepeatDao.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation




protocol RepeatDao{
    func save(_ dto: RepeatDto) throws
    func update(_ dto: RepeatDto) throws
    func find(_ routinId: UUID) throws -> RepeatDto?
    func findAll() throws -> [RepeatDto]
    func delete(_ id: UUID) throws
}
