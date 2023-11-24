//
//  CDProfileFactory.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



final class CDProfileFactory: ProfileFactory{
    func create(profileId: ProfileId, profileName: ProfileName, profileDescription: ProfileDescription, profileImage: ProfileImage, profileStyle: ProfileStyle) -> Profile {
        Profile(profileId: profileId, profileName: profileName, profileDescription: profileDescription, profileImage: profileImage, profileStyle: profileStyle)
    }
    
    
}
