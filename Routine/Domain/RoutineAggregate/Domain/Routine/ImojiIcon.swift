//
//  ImojiIcon.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation



struct ImojiIcon: ValueObject{
    let imoji: String
    
    init(_ imoji: String) {
        self.imoji = imoji
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(imoji, forKey: CodingKeys.imoji.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let imoji = coder.decodeString(forKey: CodingKeys.imoji.rawValue) else { return nil}
        self.imoji = imoji
    }
    
    
    private enum CodingKeys: String{
        case imoji = "ImojiIcon"
    }
    
}
