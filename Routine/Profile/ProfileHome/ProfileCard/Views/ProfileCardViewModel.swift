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
        self.image = model.profileImage.profileValue.toImage()
        self.style = ProfileStyleViewModel(model.profileStyle)
    }
}
