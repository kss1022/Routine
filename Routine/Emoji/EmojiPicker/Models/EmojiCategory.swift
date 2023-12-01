//
//  EmojiCategory.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

/// An object that represents category of emojis.
struct EmojiCategory: Decodable {
    /// Type-safe category type.
    let type: EmojiCategoryType
    /// Identifiers of emojis.
    let identifiers: [EmojiType.ID]
    
    enum CodingKeys: String, CodingKey {
        case type = "id"
        case identifiers = "emojis"
    }
}

/// Type-safe representation of emoji categories.
enum EmojiCategoryType: String, Decodable, CaseIterable {
    case people
    case nature
    case foods
    case activity
    case places
    case objects
    case symbols
    case flags
}
