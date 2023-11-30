//
//  ProfileCardViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit


struct ProfileCardViewModel{
    let name: String
    let description: String
    let type: MemojiType
    let style: MemojiStyle
    
    init(_ model: ProfileModel) {
        self.name = model.profileName
        self.description = model.profileIntroduction
        self.style = MemojiStyle(
            topColor: model.topColor,
            bottomColor: model.bottomColor
        )        
        
        switch model.profileImage {
        case .memoji(let memoji): type = .memoji(image: UIImage(fileName: memoji))
        case .emoji(let emoji): type = .emoji(emoji)
        case .text(let text): type = .text(text)
        }
    }

}


