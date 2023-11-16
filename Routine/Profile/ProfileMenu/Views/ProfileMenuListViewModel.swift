//
//  ProfileMenuListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation
import UIKit.UIImage



struct ProfileMenuListViewModel{
    let title: String
    let menus: [ProfileMenuViewModel]
    
    init(_ model: ProfileMenuListModel) {
        self.title = model.title
        self.menus = model.menus.map(ProfileMenuViewModel.init)
    }
}

struct ProfileMenuViewModel{
    let image: UIImage?
    let title: String
    let tapHandler: ()-> Void
    
    init(_ model: ProfileMenuModel) {
        self.image = UIImage(systemName: model.imageName)
        self.title = model.title
        self.tapHandler = model.tapHandler
    }
}
