//
//  TimerType.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation




enum TimerType: String, ValueObject{
    case tabata
    case round
    case custom
    
    init(_ timerType: String) throws{
        switch timerType{
        case "tabata":
            self = .tabata
        case "round":
            self = .round
        case "custom":
            self = .custom
        default: throw ArgumentException("This is not the right data for your type: \(timerType)")
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.rawValue, forKey: CodingKeys.timerType.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let timerType =  coder.decodeString(forKey: CodingKeys.timerType.rawValue) else {
            return nil
        }
        self.init(rawValue: timerType)
    }
    
    init?(rawValue: String) {
        switch rawValue{
        case "tabata":
            self = .tabata
        case "round":
            self = .round
        case "custom":
            self = .custom
        default: return nil
        }
    }
    
    private enum CodingKeys: String{
        case timerType
    }
}
