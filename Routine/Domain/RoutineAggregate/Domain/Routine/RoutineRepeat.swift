//
//  RoutineRepeat.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation




//struct RoutineRepeat: ValueObject{
//
//    let cycleType: CycleType
//
//    init(cycleType: CycleType){
//        self.cycleType = cycleType
//    }
//    
//    static func == (lhs: RoutineRepeat, rhs: RoutineRepeat) -> Bool {
//        false
//    }
//    
//    
//    func encode(with coder: NSCoder) {
//        cycleType.encode(with: coder)
//    }
//    
//    init?(coder: NSCoder) {
//        guard let cycleType = CycleType(coder: coder) else { return nil}
//        self.cycleType = cycleType
//    }
//    
//    private enum CodingKeys: String{
//        case routineRepeat = "RoutineRepeat"
//    }
//
//}
//
//
//
//
//
//enum CycleType{
//    case Daliy
//    case Weekliy(days : Set<Int>)
//    case Monthly(days: Set<Int>)
//    case Group
//    
//    
//    func encode(with coder: NSCoder){
//        switch self{
//        case .Daliy:
//            coder.encode("Daily", forKey: CodingKeys.CycleType.rawValue)
//        case .Weekliy(let dayOfWeeks):
//            coder.encode("Weekly", forKey: CodingKeys.CycleType.rawValue)
//            coder.encode(dayOfWeeks as NSSet, forKey: CodingKeys.Day.rawValue)
//        case .Monthly(let days):
//            coder.encode("Monthly", forKey: CodingKeys.CycleType.rawValue)
//            coder.encode(days as NSSet, forKey: CodingKeys.Day.rawValue)
//        case .Group:
//            coder.encode("Group", forKey: CodingKeys.CycleType.rawValue)
//        }
//    }
//    
//    init?(coder: NSCoder) {
//        guard let type =  coder.decodeString(forKey: CodingKeys.CycleType.rawValue)else { return  nil}
//        
//        switch type {
//        case "Daily":
//            self = .Daliy
//        case "Weekly":
//            guard let days = coder.decodeObject(of: NSSet.self, forKey: CodingKeys.Day.rawValue) as? Set<Int> else { return nil }
//            self = .Weekliy(days: days)
//        case "Monthly":
//            guard let days = coder.decodeObject(of: NSSet.self, forKey: CodingKeys.Day.rawValue) as? Set<Int> else { return nil }
//            self = .Monthly(days: days)
//        case "Group":
//            self = .Group
//        default:
//            return nil
//        }
//    }
//    
//    
//    
//    private enum CodingKeys: String{
//        case CycleType = "CycleType"
//        case Day = "Day"
//    }
//    
//}
