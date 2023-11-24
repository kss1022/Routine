//
//  ProfileUpdated.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



final class ProfileUpdated: DomainEvent{
    let profileId: ProfileId
    let profileName: ProfileName
    let profileDescription: ProfileDescription
    let profileImage: ProfileImage
    let profileStyle: ProfileStyle
    
    init(profileId: ProfileId, profileName: ProfileName, profileDescription: ProfileDescription, profileImage: ProfileImage, profileStyle: ProfileStyle) {
        self.profileId = profileId
        self.profileName = profileName
        self.profileDescription = profileDescription
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        super.init()
    }
    
    override func encode(with coder: NSCoder) {        
        profileId.encode(with: coder)
        profileName.encode(with: coder)
        profileDescription.encode(with: coder)
        profileImage.encode(with: coder)
        profileStyle.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let profileId = ProfileId(coder: coder),
              let proflieName = ProfileName(coder: coder),
              let profileDescription = ProfileDescription(coder: coder),
              let profileImage = ProfileImage(coder: coder),
              let profileStyle = ProfileStyle(coder: coder) else { return nil }
        
        self.profileId = profileId
        self.profileName = proflieName
        self.profileDescription =  profileDescription
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        
        super.init(coder: coder)
    }
        
    
    static var supportsSecureCoding: Bool = true
}
