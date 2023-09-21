//
//  RoutineDetailDao.swift
//  Routine
//
//  Created by 한현규 on 2023/09/20.
//

import Foundation



protocol RoutineDetailDao{
    func save(_ dto: RoutineDetailDto) throws
    func update(_ dto: RoutineDetailDto) throws
    func find(_ id: UUID) throws -> RoutineDetailDto?
    
    
    func updateName(_ id: UUID, name: String) throws
}

