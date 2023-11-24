//
//  ProfileImage.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation





struct ProfileImage: ValueObject{
    
    
    let profileImageType: ProfileImageType
    let profileImageValue: ProfileImageValue
    
    init(imageType: String, value: String) throws{
        guard let imageType = ProfileImageType(rawValue: imageType) else{
            throw ArgumentException("This is not the right data for your type: \(imageType)")
        }
        
        
        self.profileImageType = imageType
        
        switch imageType {
        case .memoji:
            let profileMemoji = ProfileMemoji(value)
            self.profileImageValue = .memoji(profileMemoji)
        case .emoji:
            let emoji = try ProfileEmoji(value)
            self.profileImageValue = .emoji(emoji)
        case .text:
            let text = try ProfileText(value)
            self.profileImageValue = .text(text)
        }
    }
    
    func encode(with coder: NSCoder) {
        profileImageType.encode(with: coder)
        profileImageValue.encode(with: coder)
    }
    
    init?(coder: NSCoder) {
        guard let imageType = ProfileImageType(coder: coder),
              let imageValue = ProfileImageValue(coder: coder, type: imageType)else{ return nil}
        
        self.profileImageType = imageType
        self.profileImageValue = imageValue
    }
}




struct ProfileMemoji: ValueObject{
    let imageName: String
    
    
    init(_ imageName: String){
        self.imageName = imageName
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(imageName, forKey: CodingKeys.meojiImageName.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let imageName = coder.decodeString(forKey: CodingKeys.meojiImageName.rawValue)else {
            return nil
        }
        self.imageName = imageName
    }
    
    enum CodingKeys: String{
        case meojiImageName
    }
    
}

struct ProfileEmoji: ValueObject{
    let emoji: String
    
    init(_ emoji: String) throws{
        if emoji.count != 1{
            throw ArgumentException("Invali ProfileEmoji: \(emoji)")
        }
        self.emoji = emoji
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(emoji, forKey: CodingKeys.profileEmoji.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let emoji = coder.decodeString(forKey: CodingKeys.profileEmoji.rawValue) else { return nil }
        self.emoji = emoji
    }
    
    enum CodingKeys: String{
        case profileEmoji
    }
}


struct ProfileText: ValueObject{
    let text: String
    
    init(_ text: String) throws{
        if text.count > 2{
            throw ArgumentException("MemojiText must be less than 2.")
        }
        self.text = text
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(text, forKey: CodingKeys.memojiText.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let text = coder.decodeString(forKey: CodingKeys.memojiText.rawValue) else { return nil}        
        self.text = text
    }
    
    enum CodingKeys: String{
        case memojiText
    }
    
}
