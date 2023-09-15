//
//  SnapshotRepository.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public protocol SnapshotRepository{
    func tryGetSnapshotById<T : Entity>(id: UUID, entity : inout T?, version: inout Int) -> Bool
    func saveSanpshot(id: UUID , entity: Entity, version: Int)
}
