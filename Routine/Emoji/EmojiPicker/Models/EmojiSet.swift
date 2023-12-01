//
//  EmojiSet.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

/// An object that represents set of emojis.
struct EmojiSet: Decodable {
    /// Emoji categories.
    let categories: [EmojiCategory]
    /// Emojis dictionary from which you can get emojis by ID.
    let emojis: [EmojiType.ID: EmojiType]
    /// Aliases of keywords for emojis.
    let aliases: [String: String]
}
