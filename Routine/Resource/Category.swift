//
//  Category.swift
//  Routine
//  https://github.com/levantAJ/EmojiPicker/tree/master
//  Created by 한현규 on 2023/09/27.
//

import Foundation

//func emojiList() throws -> [Category]{
//    let path = Bundle.main.path(forResource: "emojis11.0.1", ofType: "json")!
//    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//    let categories = try JSONDecoder().decode([Category].self, from: data)
//}
//
//
//enum EmojiGroup: String, Codable {
//    case frequentlyUsed
//    case smileysAndPeople
//    case animalsAndNature
//    case foodAndDrink
//    case activity
//    case travelAndPlaces
//    case objects
//    case symbols
//    case flags
//    
//    init?(index: Int) {
//        switch index {
//        case 0:
//            self = .frequentlyUsed
//        case 1:
//            self = .smileysAndPeople
//        case 2:
//            self = .animalsAndNature
//        case 3:
//            self = .foodAndDrink
//        case 4:
//            self = .activity
//        case 5:
//            self = .travelAndPlaces
//        case 6:
//            self = .objects
//        case 7:
//            self = .symbols
//        case 8:
//            self = .flags
//        default:
//            return nil
//        }
//    }
//    
//    var index: Int {
//        switch self {
//        case .frequentlyUsed:
//            return 0
//        case .smileysAndPeople:
//            return 1
//        case .animalsAndNature:
//            return 2
//        case .foodAndDrink:
//            return 3
//        case .activity:
//            return 4
//        case .travelAndPlaces:
//            return 5
//        case .objects:
//            return 6
//        case .symbols:
//            return 7
//        case .flags:
//            return 8
//        }
//    }
//    
//    var name: String {
//        switch self {
//        case .frequentlyUsed:
//            return "FREQUENTLY USED"
//        case .smileysAndPeople:
//            return "SMILEYS & PEOPLE"
//        case .animalsAndNature:
//            return "ANIMALS & NATURE"
//        case .foodAndDrink:
//            return "FOOD & DRINK"
//        case .activity:
//            return "ACTIVITY"
//        case .travelAndPlaces:
//            return "TRAVEL AND PLACES"
//        case .objects:
//            return "OBJECTS"
//        case .symbols:
//            return "SYMBOLS"
//        case .flags:
//            return "FLAGS"
//        }
//    }
//}
//
//struct Category: Codable {
//    var emojis: [Emoji]!
//    var type: EmojiGroup!
//    
//    enum CodingKeys: String, CodingKey {
//        case emojis
//        case type
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        emojis = try values.decode([[String]].self, forKey: .emojis).map { Emoji(emojis: $0) }
//        type = try values.decode(EmojiGroup.self, forKey: .type)
//    }
//}
//
//struct Emoji: Codable {
//    let emojis: [String]
//}
