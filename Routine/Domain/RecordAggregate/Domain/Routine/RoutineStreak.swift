//
//  RoutineStreak.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation


//Streak



final class RoutineStreak{
    private(set) var streakId: StreakId!
    private(set) var routineId: RoutineId!
    private(set) var dates: Set<RecordDate>!
    private(set) var streakCount: StreakCount!
    
    init(streakId: StreakId, routineId: RoutineId, date: RecordDate, steakCount: StreakCount) {
        self.streakId = streakId
        self.routineId = routineId
        self.dates = Set<RecordDate>()
        self.dates.insert(date)
        self.streakCount = steakCount
    }
    
    func setComplete(isComplete: Bool, recentDate: RecordDate) throws{
        if isComplete{
            self.dates.remove(recentDate)
            
        }else{
            self.dates.insert(recentDate)
        }
        
        
        
        
    }
    
    
    
//    func update(recentDate: RecordDate) throws{
//        //if self.recentDate >= recentDate{ throw Error}
//        self.streakCount = streakCount + 1
//        self.endDate = recentDate
////        if date == nil{
////            throw ArgumentException("Date should not be nil when completing Streak.")
////        }
////        self.recentDate = RecordDate(date!)
//    }
//    
//    func rollBack(recentDate: RecordDate) throws{
//        //if self.recentDate <= recentDate{ throw Error}
//        self.streakCount = try streakCount - 1
//        self.endDate = recentDate
//    }
//    

    
    
}

