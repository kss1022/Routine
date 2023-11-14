//
//  RoutineTotalRecordDao.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




protocol RoutineTotalRecordDao{
    func save(_ dto: RoutineTotalRecordDto) throws
    func find(routineId: UUID) throws -> RoutineTotalRecordDto?
    
    func complete(routineId: UUID) throws
    func cancel(routineId: UUID) throws
}

