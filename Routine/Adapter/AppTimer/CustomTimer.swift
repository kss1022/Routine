//
//  CustomTimer.swift
//  Routine
//
//  Created by 한현규 on 10/23/23.
//

import Foundation


// Folder
//enum CustomTime{
//    case time(time: TimeInterval)
//    case timer(timer: CustimTimer)
//}
//
//
//class CustimTimer{
//    
//    var customTimes: [CustomTime]
//    
//    var index: Int
//    var round: Int
//    var remainRound: Int
//    
//    
//    init(customTimes: [CustomTime], round: Int) {
//        self.customTimes = customTimes
//        self.round = round
//        self.remainRound = round
//        self.index = 0
//    }
//    
//    func next() -> TimeInterval?{
//        guard let time = nextCustomTime() else { return nil }
//        
//        switch time {
//        case .time(let time):
//            return time
//        case .timer(let round):
//            //handle inner CustomTimer
//            if let innerRound = round.next(){
//                return innerRound
//            }else{
//                return next()
//            }
//        }
//    }
//    
//    
//    private func nextCustomTime() -> CustomTime?{
//        let nextIndex = self.index + 1
//        if customTimes.count <= nextIndex{
//            if self.remainRound == 0{
//                //finish
//                return nil
//            }
//            
//            
//            self.remainRound -= 1
//            self.index = 0
//            return self.customTimes[0]
//        }
//        
//        self.index += 1
//        return self.customTimes[0]
//    }
//    
//}
//
//
//final class CustomTimer{
//    
//    
//    
//}
