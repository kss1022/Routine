//
//  ProfileCreated.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation


final class ProfileCreated: DomainEvent{    
    let profileId: ProfileId
    let profileName: ProfileName
    let profileIntroduction: ProfileIntroduction
    let profileImage: ProfileImage
    let profileStyle: ProfileStyle
    
    init(profileId: ProfileId, profileName: ProfileName, profileIntroduction: ProfileIntroduction, profileImage: ProfileImage, profileStyle: ProfileStyle) {
        self.profileId = profileId
        self.profileName = profileName
        self.profileIntroduction = profileIntroduction
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        profileId.encode(with: coder)
        profileName.encode(with: coder)
        profileIntroduction.encode(with: coder)
        profileImage.encode(with: coder)
        profileStyle.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let profileId = ProfileId(coder: coder),
              let proflieName = ProfileName(coder: coder),
              let profileIntroduction = ProfileIntroduction(coder: coder),
              let profileImage = ProfileImage(coder: coder),
            let profileStyle = ProfileStyle(coder: coder) else { return nil }
        
        self.profileId = profileId
        self.profileName = proflieName
        self.profileIntroduction =  profileIntroduction
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        
        super.init(coder: coder)
    }
        
    
    static var supportsSecureCoding: Bool = true
}
