//
//  TimerSectionValueModel.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation


enum TimerSectionValueModel: Hashable{
    case countdown(min: Int, sec: Int)
    case count(count: Int)
    
    init(_ dto: TimerSectionValueDto){
        switch dto {
        case .countdown(let min, let sec): self = .countdown(min: min, sec: sec)
        case .count(let count): self = .count(count: count)
        }
    }
    
    func rawValue() -> String{
        switch self {
        case .countdown(let min, let sec):
            return  String(format: "%02d:%02d", min, sec)
        case .count(let count):
            return  "\(count)"
        }
    }
    
    var min: Int?{
        guard case .countdown(let min, _) = self else {
            return nil
        }
        
        return min
    }
    
    var sec: Int?{
        guard case .countdown(_ , let sec) = self else {
            return nil
        }
        
        return sec
    }
    
    var count: Int?{
        guard case .count(let count) = self else {
            return nil
        }
        
        return count
    }
}




//struct TimerSectionValueModel: Hashable{
//    let min: Int?
//    let sec: Int?
//    let count: Int?
//
//
//    init(_ dto: TimerSectionValueDto){
//        switch dto {
//        case .countdown(let min, let sec):
//            self.min = min
//            self.sec = sec
//            self.count = nil
//        case .count(let count):
//            self.min = nil
//            self.sec = nil
//            self.count = count
//        }
//    }
//
//    init(min: Int , sec: Int){
//        self.min = min
//        self.sec = sec
//        self.count = nil
//    }
//
//    init(count: Int){
//        self.min = nil
//        self.sec = nil
//        self.count = count
//    }
//
//    func rawValue() -> String{
//        if self.count != nil{ return "\(self.count!)" }
//
//        guard let min = self.min,
//              let sec = self.sec else { fatalError()}
//        return  String(format: "%02d:%02d", min, sec)
//    }
//
