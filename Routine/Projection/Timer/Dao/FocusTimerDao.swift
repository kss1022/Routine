//
//  FocusTimerDao.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation


protocol FocusTimerDao{
    func save(_ dto: FocusTimerDto) throws
    func update(_ dto: FocusTimerDto) throws
    func find(_ id: UUID) throws -> FocusTimerDto?    
    func delete(_ id: UUID) throws
}
