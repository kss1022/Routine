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
    let image: UIImage?
    let style: ProfileStyleViewModel
    
    init(_ model: ProfileModel) {
        self.name = model.profileName
        self.description = model.profileDescription
        self.style = ProfileStyleViewModel(model.profileStyle)
        
        switch model.profileImage {
        case .memoji(let memoji): self.image = UIImage(fileName: memoji)
        case .emoji(let emoji): self.image = emoji.toImage()
        case .text(let text): self.image = text.toImage()
        }
    }

}


