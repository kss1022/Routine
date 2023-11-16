//
//  ProfileMenuModel.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation



struct ProfileMenuListModel{
    let title: String
    let menus: [ProfileMenuModel]
}

struct ProfileMenuModel{
    let imageName: String
    let title: String
    let tapHandler: ()-> Void
}
