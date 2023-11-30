//
//  CDProfileFactory.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



final class CDProfileFactory: ProfileFactory{
    func create(profileId: ProfileId, profileName: ProfileName, profileIntroduction: ProfileIntroduction, profileImage: ProfileImage, profileStyle: ProfileStyle) -> Profile {
        Profile(profileId: profileId, profileName: profileName, profileIntroduction: profileIntroduction, profileImage: profileImage, profileStyle: profileStyle)
    }
    
    
}
