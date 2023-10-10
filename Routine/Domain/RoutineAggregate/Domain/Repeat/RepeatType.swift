//
//  RoutineRepeatType.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation



enum RepeatType: String, ValueObject{

    case doItOnce
    case daliy
    case weekliy
    case monthly
    
    func encode(with coder: NSCoder) {
        coder.encode(self.rawValue, forKey: CodingKeys.routineRepeatType.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let getType =  coder.decodeString(forKey: CodingKeys.routineRepeatType.rawValue),
              let type = RepeatType(rawValue: getType) else { return nil }
        self = type
    }
    
    
    private enum CodingKeys: String{
        case routineRepeatType
    }
}
