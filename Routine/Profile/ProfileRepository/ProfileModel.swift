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
    let profileDescription: String
    let profileImage: ProfileImageModel
    let profileStyle: ProfileStyleModel
    
    init(_ dto: ProfileDto) {
        self.profileId = dto.profileId
        self.profileName = dto.profileName
        self.profileDescription = dto.profileDescription
        self.profileImage = ProfileImageModel(dto.profileImage)
        self.profileStyle = ProfileStyleModel(dto.profileStyle)
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
