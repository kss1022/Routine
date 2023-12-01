//
//  EmojiType.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//


/// An object that represents emoji.
struct EmojiType: Decodable, Identifiable {
    /// Emoji identifier.
    let id: String
    /// Name of an emoji.
    let name: String
    /// Keywords for an emoji.
    let keywords: [String]
    /// Skin tones.
    let skins: [EmojiSkin]
    /// Version in which the emoji appeared.
    let version: Double
    /// Skin tone number. We save it so user can use the skin he chose.
    var skinToneIndex = 0
    
    enum CodingKeys: String, CodingKey {
        case id, name, keywords, skins, version
    }
}

extension EmojiType {
    /// String emoji. For example: 😄
    ///
    /// Shows in the collection view.
    var emoji: String {
        return skins[skinToneIndex].native
    }
}



struct EmojiSkin: Decodable {
    /// Unicode.
    let unified: String
    /// Emoji as symbol. For example: 😄
    let native: String
}
