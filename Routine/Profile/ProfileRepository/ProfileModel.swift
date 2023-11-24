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



struct ProfileImageModel{
    let profileType: ProfilImageTypeModel
    let profileValue: String
    
    init(_ dto: ProfileImageDto) {
        self.profileType = ProfilImageTypeModel(dto.profileImageType)
        self.profileValue = dto.profileImageValue
    }
}

enum ProfilImageTypeModel: String{
    case memoji
    case emoji
    case text
    
    init(_ dto: ProfileImageTypeDto){
        switch dto {
        case .memoji: self = .memoji
        case .emoji: self = .emoji
        case .text: self = .text
        }
    }
}
