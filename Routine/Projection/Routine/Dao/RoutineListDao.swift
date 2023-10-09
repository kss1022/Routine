//
//  RoutineListDao.swift
//  Routine
//
//  Created by 한현규 on 2023/09/20.
//

import Foundation


protocol RoutineListDao{
    func save(_ dto: RoutineListDto) throws
    func update(_ dto: RoutineListDto) throws
    func updateName(_ id: UUID, name: String) throws
    func find(_ id: UUID) throws -> RoutineListDto?
    func findAll() throws -> [RoutineListDto]
    func delete(_ id: UUID) throws
}

