//
//  ProfileModel.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation




struct ProfileModel{
    let profileId: UUID
    let profileName: String
    let profileIntroduction: String
    let profileImage: ProfileImageModel
    let topColor: String
    let bottomColor: String
    
    init(_ dto: ProfileDto) {
        self.profileId = dto.profileId
        self.profileName = dto.profileName
        self.profileIntroduction = dto.profileIntroduction
        self.profileImage = ProfileImageModel(dto.profileImage)
        self.topColor = dto.profileStyle.topColor
        self.bottomColor = dto.profileStyle.bottomColor
    }
}



enum ProfileImageModel{
    case memoji(memoji: String)
    case emoji(emoji: String)
    case text(text: String)
    
    init(_ dto: ProfileImageDto){
        let value = dto.profileImageValue
        switch dto.profileImageType {
        case .memoji: self = .memoji(memoji: value)
        case .emoji: self = .emoji(emoji: value)
        case .text: self = .text(text: value)
        }
    }
    
}
