//
//  EmojiStyle.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import Foundation
import UIKit


public struct EmojiStyle: Equatable{
    let hex : String
    let color: UIColor?
    
    init?(hex: String) {
        guard let color = UIColor(hex: hex) else {
            Log.e("EmojiStyle hex to UIColor: \(hex) is nil")
            return nil
        }
        
        self.hex = hex
        self.color = color
    }
}
