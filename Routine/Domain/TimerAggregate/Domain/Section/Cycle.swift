//
//  Cycle.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation


struct Cycle: ValueObject{
    let name: String
    let description: String
    let `repeat`: Int
    let emoji: String
    let tint: String
    
    init(_ command: RepeatSectionCommand) throws{
        if command.name.count > 50{ throw ArgumentException("Cycle's name Length must less then 50")  }
        
        if command.description.count > 50{ throw ArgumentException("Cycle's descriptoin Length must less then 50")  }
        
        if command.repeat < 1 || command.repeat > 99{
            throw ArgumentException("Repeat must be in the range 1 ~ 99")
        }
        
        self.name = command.name
        self.description = command.description
        self.repeat = command.repeat
        self.emoji = command.emoji
        self.tint = command.tint
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.name.rawValue)
        coder.encode(description, forKey: CodingKeys.description.rawValue)
        coder.encodeInteger(`repeat`, forKey: CodingKeys.repeat.rawValue)
        coder.encode(emoji, forKey: CodingKeys.emoji.rawValue)
        coder.encode(tint, forKey: CodingKeys.tint.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let name = coder.decodeString(forKey: CodingKeys.name.rawValue),
              let description = coder.decodeString(forKey: CodingKeys.description.rawValue),
              let emoji = coder.decodeString(forKey: CodingKeys.emoji.rawValue),
              let tint = coder.decodeString(forKey: CodingKeys.tint.rawValue) else { return nil}
        
        self.name = name
        self.description = description
        self.repeat = coder.decodeInteger(forKey: CodingKeys.repeat.rawValue)
        self.emoji = emoji
        self.tint = tint
    }
    
    private enum CodingKeys: String{
        case name = "CycleName"
        case description = "CycleDescription"
        case `repeat` = "CycleRepeat"
        case emoji = "CycleEmoji"
        case tint = "CycleTint"
    }
}
