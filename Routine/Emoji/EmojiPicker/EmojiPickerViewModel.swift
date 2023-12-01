//
//  EmojiPickerViewModel.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//


import Foundation


/// Emoji Picker view model.
final class EmojiPickerViewModel{

    private let emojiSet: EmojiSet

    var selectedEmoji: String
    var selectedEmojiCategoryIndex: Int

    init(emojiManager: EmojiManagerProtocol) {
        selectedEmoji = ""
        selectedEmojiCategoryIndex = 0
        
        emojiSet = emojiManager.provideEmojis()
    }
    
    // MARK: - Internal Methods
    func numberOfSections() -> Int {
        return emojiSet.categories.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return emojiSet.categories[section].identifiers.count
    }
    
    func emoji(at indexPath: IndexPath) -> String {
        let name = emojiSet.categories[indexPath.section].identifiers[indexPath.row]
        return emojiSet.emojis[name]?.emoji ?? "⚠️"
    }
    
    func sectionHeader(for section: Int) -> String {
        return NSLocalizedString(
            emojiSet.categories[section].type.rawValue,
            bundle: .module,
            comment: ""
        )
    }
}
