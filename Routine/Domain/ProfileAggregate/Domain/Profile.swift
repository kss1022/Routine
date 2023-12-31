//
//  Profile.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation




final class Profile: DomainEntity{
        
    private(set) var profileId: ProfileId!
    private(set) var profileName: ProfileName!
    private(set) var profileIntroduction: ProfileIntroduction!
    private(set) var profileImage: ProfileImage!
    private(set) var profileStyle: ProfileStyle!
    
    
    init(profileId: ProfileId, profileName: ProfileName, profileIntroduction: ProfileIntroduction, profileImage: ProfileImage, profileStyle: ProfileStyle){
        self.profileId = profileId
        self.profileName = profileName
        self.profileIntroduction = profileIntroduction
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        
        super.init()

        
        changes.append(
            ProfileCreated(profileId: profileId, profileName: profileName, profileIntroduction: profileIntroduction, profileImage: profileImage, profileStyle: profileStyle)
        )
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? ProfileCreated{
            when(created)
        }else if let updated = event as? ProfileUpdated{
            when(updated)
        }
    }
    
    private func when(_ event: ProfileCreated){
        self.profileId = event.profileId
        self.profileName = event.profileName
        self.profileIntroduction = event.profileIntroduction
        self.profileImage = event.profileImage
        self.profileStyle = event.profileStyle
    }
    
    private func when(_ event: ProfileUpdated){
        self.profileId = event.profileId
        self.profileName = event.profileName
        self.profileIntroduction = event.profileIntroduction
        self.profileImage = event.profileImage
        self.profileStyle = event.profileStyle
    }
    
    func updateProfile(profileName: ProfileName, profileIntroduction: ProfileIntroduction, profileImage: ProfileImage, profileStyle: ProfileStyle){
        self.profileName = profileName
        self.profileIntroduction = profileIntroduction
        self.profileImage = profileImage
        self.profileStyle = profileStyle
        changes.append(ProfileUpdated(profileId: self.profileId, profileName: profileName, profileIntroduction: profileIntroduction, profileImage: profileImage, profileStyle: profileStyle))
    }
    
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        
        profileId.encode(with: coder)
        profileName.encode(with: coder)
        profileIntroduction.encode(with: coder)
        profileImage.encode(with: coder)
        profileStyle.encode(with: coder)
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



