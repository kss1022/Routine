//
//  MemojiModel.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation
import UIKit



public enum MemojiType: Equatable {
    case memoji(image: UIImage?), emoji(String), text(String)
}


struct MemojiStyle{
    let topColor: UIColor?
    let bottomColor: UIColor?
    
    init(topColor: String, bottomColor: String) {
        self.topColor = UIColor(hex: topColor)
        self.bottomColor = UIColor(hex: bottomColor)
    }
}
