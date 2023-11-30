//
//  ProfileApplicationService.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



final class ProfileApplicationService: ApplicationService{
    
    internal var eventStore: EventStore
    internal var snapshotRepository: SnapshotRepository
    
    private let profileFactory: ProfileFactory
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        profileFactory: ProfileFactory
    ) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.profileFactory = profileFactory
    }
    
    func when(_ command: CreateProfile) async throws{
        do{
            Log.v("When (\(CreateProfile.self)):  \(command)")

            let profileId = ProfileId(UUID())
            let profileName = try ProfileName( command.name)
            let profileIntroduction = try ProfileIntroduction(command.description)
            let profileImage = try ProfileImage(imageType: command.imageType, value: command.imageValue)
            let profileStyle = ProfileStyle(topColor: command.topColor, bottomColor: command.bottomColor)
            
            let profile = profileFactory.create(profileId: profileId, profileName: profileName, profileIntroduction: profileIntroduction, profileImage: profileImage, profileStyle: profileStyle)
            
            try eventStore.appendToStream(id: profile.profileId.id, expectedVersion: -1, events: profile.changes)
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: UpdateProfile) async throws{
        do{
            Log.v("When (\(UpdateProfile.self)):  \(command)")
                        
            let profileId = ProfileId(command.profileId)
            let profileName = try ProfileName(command.name)
            let profileIntroduction = try ProfileIntroduction(command.description)
            let profileImage = try ProfileImage(imageType: command.imageType, value: command.imageValue)
            let profileStyle = ProfileStyle(topColor: command.topColor, bottomColor: command.bottomColor)
            
            try update(id: command.profileId) { (profile: Profile) in
                profile.updateProfile(profileName: profileName, profileIntroduction: profileIntroduction, profileImage: profileImage, profileStyle: profileStyle)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
}
