//
//  RoutineTopAcheiveDao.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation



protocol RoutineTopAcheiveDao{
    func find() throws -> [RoutineTopAcheiveDto]
}
