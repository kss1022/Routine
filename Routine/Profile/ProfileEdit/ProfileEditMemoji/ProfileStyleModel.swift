//
//  ProfileStyleModel.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation




struct ProfileStyleModel{
    let topColor: String
    let bottomColor: String
    
    init(topColor: String, bottomColor: String) {
        self.topColor = topColor
        self.bottomColor = bottomColor
    }
    
    init(_ dto: ProfileStyleDto) {
        self.topColor = dto.topColor
        self.bottomColor = dto.bottomColor
    }
}
