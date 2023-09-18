//
//  SnapshotRepository.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CoreData


public protocol SnapshotRepository{
    func tryGetSnapshotById<T : Entity>(id: UUID, entity : inout T?, version: inout Int) throws -> Bool
    func saveSanpshot(id: UUID , entity: Entity, version: Int) throws
}
