//
//  EmojiManager.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation


protocol EmojiManagerProtocol {
    func provideEmojis() -> EmojiSet
}


final class EmojiManager: EmojiManagerProtocol {
    
    private let decoder = JSONDecoder()
    
    // Version of emoji set.
    // The value is `5` by default.    
    private var emojiVersion: String {
        switch deviceVersion {
        case 12.1...13.1: return "11"
        case 13.2...14.1: return "12.1"
        case 14.2...14.4: return "13"
        case 14.5...15.3: return "13.1"
        case 15.4...: return "14"
        default: return "5"
        }
    }
    
    // Version of operating system of a device.
    // It takes major and minor version of a device and returns it as `15.5`.
    private var deviceVersion: Double {
        let operatingSystemVersion = ProcessInfo().operatingSystemVersion
        return Double(operatingSystemVersion.majorVersion) + Double(operatingSystemVersion.minorVersion) / 10
    }
    
    func provideEmojis() -> EmojiSet {
        guard let path = Bundle.module.path(forResource: emojiVersion, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else {
            fatalError("Could not get data from \"\(emojiVersion).json\" file")
        }
        
        guard let emojiSet = try? decoder.decode(EmojiSet.self, from: data)
        else {
            fatalError("Could not get emoji set from data: \(data)")
        }
        
        return emojiSet
    }
}
