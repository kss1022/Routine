//
//  ProfileImageValue.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



enum ProfileImageValue: ValueObject{
    case memoji(ProfileMemoji)
    case emoji(ProfileEmoji)
    case text(ProfileText)
    
    func encode(with coder: NSCoder) {
        switch self {
        case .memoji(let profileMemoji):
            profileMemoji.encode(with: coder)
        case .emoji(let profileEmoji):
            profileEmoji.encode(with: coder)
        case .text(let profileText):
            profileText.encode(with: coder)
        }
    }
    
    init?(coder: NSCoder) {
        fatalError("You must use with ProfileImageType")
    }
    
    init?(coder: NSCoder, type: ProfileImageType){
        switch type {
        case .memoji:
            guard let memoji = ProfileMemoji.init(coder: coder) else { return nil }
            self = .memoji(memoji)
        case .emoji:
            guard let emoji = ProfileEmoji(coder: coder) else{ return nil }
            self = .emoji(emoji)
        case .text:
            guard let text = ProfileText(coder: coder) else { return nil}
            self = .text(text)
        }
    }
}
