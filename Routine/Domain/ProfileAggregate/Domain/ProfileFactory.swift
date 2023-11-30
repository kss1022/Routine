//
//  ProfileFactory.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



protocol ProfileFactory{
    func create(profileId: ProfileId, profileName: ProfileName, profileIntroduction: ProfileIntroduction, profileImage: ProfileImage, profileStyle: ProfileStyle) -> Profile
}
