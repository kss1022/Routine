//
//  RoutineTotalRecord.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import Foundation




//final class RoutineTotalRecord{
//    let routineId: RoutineId
//    let totalDone: RecordTotalCount
//    let doneThisMonth: RecordDoneThisMonth
//    let currentSteak: RoutineStreak
//    let bestStreak: RoutineStreak
//    
//    init(routineId: RoutineId, doneThisMonth: RecordDoneThisMonth, totalDone: RecordTotalCount, currentSteak: RoutineStreak, bestStreak: RoutineStreak) {
//        self.routineId = routineId
//        self.doneThisMonth = doneThisMonth
//        self.totalDone = totalDone
//        self.currentSteak = currentSteak
//        self.bestStreak = bestStreak
//    }
//}


//struct RecordTotalCount: ValueObject{
//    let count: Int
//    
//    init(_ count: Int) {
//        self.count = count
//    }
//    
//    func encode(with coder: NSCoder) {
//        
//    }
//    
//    init?(coder: NSCoder) {
//        nil
//    }
//}


//struct RecordDoneThisMonth: ValueObject{
//    
//    private(set) var recordMonth: [RecordMonth: Int]!
//    
//    
//    init(){
//        
//    }
//    
//    func encode(with coder: NSCoder) {
//        
//    }
//    
//    init?(coder: NSCoder) {
//        nil
//    }
//    
//}


//struct RecordMonth: ValueObject, Hashable{
//    let year: Int
//    let month: Int
//    
//    init(date: Date){
//        let calendar = Calendar.current
//        year = calendar.component(.year, from: date)
//        month = calendar.component(.month, from: date)
//    }
//        
//
//    func encode(with coder: NSCoder) {
//        coder.encodeInteger(year, forKey: CodingKeys.year.rawValue)
//        coder.encodeInteger(month, forKey: CodingKeys.month.rawValue)
//    }
//
//    init?(coder: NSCoder) {
//        self.year = coder.decodeInteger(forKey: CodingKeys.year.rawValue)
//        self.month = coder.decodeInteger(forKey: CodingKeys.month.rawValue)
//    }
//
//    private enum CodingKeys: String{
//        case year
//        case month
//        case day
//    }
//}
