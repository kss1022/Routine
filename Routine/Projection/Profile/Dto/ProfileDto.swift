//
//  ProfileDto.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



struct ProfileDto: Codable{
    let profileId: UUID
    let profileName: String
    let profileIntroduction: String
    let profileImage: ProfileImageDto
    let profileStyle: ProfileStyleDto
    
    
    init(profileId: UUID, profileName: String, profileIntroduction: String, profileImage: ProfileImage, profileStyle: ProfileStyle) {
        self.profileId = profileId
        self.profileName = profileName
        self.profileIntroduction = profileIntroduction
        self.profileImage = ProfileImageDto(profileImage)
        self.profileStyle = ProfileStyleDto(profileStyle)
    }
}

struct ProfileImageDto: Codable{
    let profileImageType: ProfileImageTypeDto
    let profileImageValue: String
    
    init(_ profileImage: ProfileImage) {
        self.profileImageType = ProfileImageTypeDto(profileImage.profileImageType)
        switch profileImage.profileImageValue {
        case .memoji(let profileMemoji): self.profileImageValue = profileMemoji.imageName
        case .emoji(let profileEmoji): self.profileImageValue = profileEmoji.emoji
        case .text(let profileText): self.profileImageValue = profileText.text
        }
    }
}

enum ProfileImageTypeDto: String, Codable{
    case memoji
    case emoji
    case text
    
    init(_ type: ProfileImageType){
        switch type {
        case .memoji: self = .memoji
        case .emoji: self = .emoji
        case .text: self = .text
        }
    }
}



struct ProfileStyleDto: Codable{
    let topColor: String
    let bottomColor: String
    
    init(_ profileStyle: ProfileStyle){
        self.topColor = profileStyle.topColor
        self.bottomColor = profileStyle.bottomColor
    }
}
