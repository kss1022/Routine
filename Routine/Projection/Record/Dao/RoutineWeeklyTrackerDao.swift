//
//  RoutineWeeklyTrackerDao.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation



protocol RoutineWeeklyTrackerDao{
    func find(year: Int, weekOfYear: Int) throws -> [RoutineWeeklyTrackerDto]
}
