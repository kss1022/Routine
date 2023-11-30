//
//  ProfileRepository.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation




protocol ProfileRepository{
    var profile :ReadOnlyCurrentValuePublisher<ProfileModel?>{ get }
    
    func fetchProfile() async throws
}


final class ProfileRepositoryImp: ProfileRepository{
    
    var profile: ReadOnlyCurrentValuePublisher<ProfileModel?>{ profileSubject }
    private let profileSubject = CurrentValuePublisher<ProfileModel?>(nil)
    
    
    func fetchProfile() async throws {
        if let profile = try profileReadModel.profile()
            .map(ProfileModel.init){
            profileSubject.send(profile)
            Log.v("Fetch Profile: \(profile)")
        }
    }
    
    
    
    private let profileReadModel: ProfileReadModelFacade
    
    init(profileReadModel: ProfileReadModelFacade){
        self.profileReadModel = profileReadModel        
    }
    
}
