//
//  RoutineStreak.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation





final class RoutineStreak{
    
    private(set) var routineId: RoutineId!
    private(set) var recentDate: RecordDate!
    private(set) var streakCount: RecordStreakCount!
    
    init(routineId: RoutineId, recentDate: RecordDate, recordStreakCount: RecordStreakCount) {
        self.routineId = routineId
        self.recentDate = recentDate
        self.streakCount = recordStreakCount
    }
    
    
    func update(recentDate: RecordDate) throws{
        //if self.recentDate >= recentDate{ throw Error}
        self.streakCount = streakCount + 1
        self.recentDate = recentDate
//        if date == nil{
//            throw ArgumentException("Date should not be nil when completing Streak.")
//        }
//        self.recentDate = RecordDate(date!)
    }
    
    func rollBack(recentDate: RecordDate) throws{
        //if self.recentDate <= recentDate{ throw Error}
        self.streakCount = try streakCount - 1
        self.recentDate = recentDate
    }
    

    
    
}


struct RecordStreakCount: ValueObject{
    let count: Int
    
    
    init(_ count: Int) throws{
        if count < 0{
            throw ArgumentException("StreakCount must be greater than 0")
        }
        
        self.count = count
    }
    
    func encode(with coder: NSCoder) {
        
    }
    
    init?(coder: NSCoder) {
        nil
    }
    
    
    
    static func +(left: RecordStreakCount, right: Int) -> RecordStreakCount{
        return try! RecordStreakCount(left.count + 1)
    }
    
    static func -(left: RecordStreakCount, right: Int) throws -> RecordStreakCount{
        return try RecordStreakCount(left.count - 1)
    }
    
}
