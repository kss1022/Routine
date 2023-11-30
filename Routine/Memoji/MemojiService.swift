//
//  MemojiService.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation



final class MemojiService{
    
    func styleModels() -> [MemojiStyle]{
        
        [
            ("#A8ADBAFF", "#878C96FF"),
            ("#D5CCF7FF", "#B5A4F2FF"),
            ("#B3D5F0FF", "#76B3E2FF"),
            ("#F5B7CCFF", "#EE7EA2FF"),
            ("#F5DAAFFF", "#EDB96EFF"),
            ("#CAF2BDFF", "#A0E787FF"),
            ("#E2C6C3FF", "#C89792FF"),
            ("#F0C1A5FF", "#E49165FF"),
            ("#D6CDDEFF", "#B4A5C2FF"),
            ("#C7D7E7FF", "#9DB8D5FF"),
            ("#D0E8EAFF", "#A9D5D8FF"),
            ("#EEB3EDFF", "#E27DDDFF"),
            ("#AAF0F2FF", "#67E4E8FF"),
            ("#B0F4C3FF", "#70EB91FF"),
            ("#D9D4D0FF", "#B9B0A7FF"),
            ("#E6D6BFFF", "#D1B48AFF"),
            ("#D5DDD0FF", "#B0C2AAFF"),
            ("#8E8E8EFF", "#333333FF")
        ].map { (topColor, bottomColor) in
            MemojiStyle(topColor: topColor, bottomColor: bottomColor)
        }
    }
    
}
