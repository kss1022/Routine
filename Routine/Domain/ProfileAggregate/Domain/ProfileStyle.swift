//
//  ProfileStyle.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation




struct ProfileStyle: ValueObject{
    let topColor: String
    let bottomColor: String
    
    init(topColor: String, bottomColor: String) {
        self.topColor = topColor
        self.bottomColor = bottomColor
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(topColor, forKey: CodingKeys.topColor.rawValue)
        coder.encode(bottomColor, forKey: CodingKeys.bottomColor.rawValue)
    }
    
    init?(coder: NSCoder) {
        guard let topGradient = coder.decodeString(forKey: CodingKeys.topColor.rawValue),
              let bottomGradient = coder.decodeString(forKey: CodingKeys.bottomColor.rawValue) else { return nil }
        
        self.topColor = topGradient
        self.bottomColor = bottomGradient
    }
    
    
    enum CodingKeys: String{
        case topColor
        case bottomColor
    }
    
}
