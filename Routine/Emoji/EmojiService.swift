//
//  EmojiService.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import Foundation



// TODO: EmojiService


final class EmojiService{
    func styles() -> [EmojiStyle]{
        [
            // similar memoji tint
            "#A8ADBAFF",
            "#D5CCF7FF",
            "#B3D5F0FF",
            "#F5B7CCFF",
            "#F5DAAFFF",
            "#CAF2BDFF",
            "#E2C6C3FF",
            "#F0C1A5FF",
            "#D6CDDEFF",
            "#C7D7E7FF",
            "#D0E8EAFF",
            "#EEB3EDFF",
            "#AAF0F2FF",
            "#B0F4C3FF",
            "#D9D4D0FF",
            "#E6D6BFFF",
            "#D5DDD0FF",
            "#8E8E8EFF",
            
            // my custom tint
            "#82B1FFFF"
        ].compactMap { hex in
            EmojiStyle(hex: hex)
        }
    }
}
