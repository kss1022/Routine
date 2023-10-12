//
//  RecordDao.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



protocol RecordDao{
    func save(_ dto: RecordDto) throws
    func updateComplete(recordId: UUID, isComplete: Bool, completeAt: Date) throws
    func find(routineId: UUID, date: String) throws -> RecordDto?
    func findAll(_ date: String) throws -> [RecordDto]
    func findAll(_ routindId: UUID) throws -> [RecordDto]
}
