//
//  ProfileImageType.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



enum ProfileImageType: String, ValueObject{
    case memoji
    case emoji
    case text
    
    func encode(with coder: NSCoder) {
        coder.encode(self.rawValue, forKey: CodingKeys.imageType.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let getType = coder.decodeString(forKey: CodingKeys.imageType.rawValue),
              let type = ProfileImageType(rawValue: getType) else { return nil}
        self = type
    }
    
    enum CodingKeys: String{
        case imageType
    }
}
