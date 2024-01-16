//
//  Cooldown.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation



struct Cooldown: ValueObject{
    let name: String
    let description: String
    let min: Int
    let sec: Int
    let emoji: String
    let tint: String
    
    init(_ command: TimeSectionCommand) throws{
        if command.name.count > 50{ throw ArgumentException("Cooldown's name Length must less then 50")  }
        
        if command.description.count > 50{ throw ArgumentException("Cooldown's descriptoin Length must less then 50")  }
        
        if command.min < 0{
            throw ArgumentException("Min must be least than 0")
        }
        
        if command.sec < 0 || command.sec > 60{
            throw ArgumentException("Sec must be in the range 1 ~ 60")
        }
        
        if command.min == 0 && command.sec == 0{
            throw ArgumentException("Time must be greater than zero.")
        }
        
        self.name = command.name
        self.description = command.description
        self.min = command.min
        self.sec = command.sec
        self.emoji = command.emoji
        self.tint = command.tint
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.name.rawValue)
        coder.encode(description, forKey: CodingKeys.description.rawValue)
        coder.encodeInteger(min, forKey: CodingKeys.min.rawValue)
        coder.encodeInteger(sec, forKey: CodingKeys.sec.rawValue)
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
        self.min = coder.decodeInteger(forKey: CodingKeys.min.rawValue)
        self.sec = coder.decodeInteger(forKey: CodingKeys.sec.rawValue)
        self.emoji = emoji
        self.tint = tint
    }
    
    private enum CodingKeys: String{
        case name = "CooldownName"
        case description = "CooldownDescription"
        case min = "CooldownMin"
        case sec = "CooldownSec"
        case emoji = "CooldownEmoji"
        case tint = "CooldownTint"
    }
}
