//
//  TimerSectionList.swift
//  Routine
//
//  Created by 한현규 on 10/20/23.
//

import Foundation


protocol TimerSectionListDao{
    func save(_ dtos: [TimerSectionListDto]) throws
    func update(_ dto: [TimerSectionListDto]) throws
    func find(_ id: UUID) throws -> [TimerSectionListDto]
    func delete(_ id: UUID) throws
}
