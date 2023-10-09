//
//  Emoji.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



struct Emoji: ValueObject{
    let emoji: String
    
    init(_ emoji: String) {
        self.emoji = emoji
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(emoji, forKey: CodingKeys.emoji.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let emoji = coder.decodeString(forKey: CodingKeys.emoji.rawValue) else { return nil}
        self.emoji = emoji
    }
    
    
    private enum CodingKeys: String{
        case emoji = "Emoji"
    }
    
}
