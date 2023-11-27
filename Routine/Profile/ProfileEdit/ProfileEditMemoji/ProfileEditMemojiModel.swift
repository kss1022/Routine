//
//  ProfileEditMemojiModel.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import Foundation



enum ProfileEditMemojiModel{
    case memoji(data: Data?)
    case emoji(emoji: String)
    case text(text: String)
    
    func type() -> String{
        switch self {
        case .memoji: "memoji"
        case .emoji: "emoji"
        case .text: "text"
        }
    }
    
    func value() -> String{
        switch self {
        case .memoji: "profileImage"
        case .emoji(let emoji): emoji
        case .text(let text): text            
        }
    }
}
