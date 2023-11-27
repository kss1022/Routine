//
//  ProfileSetup.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation


final class ProfileSetup{
    
    private let profileApplicationService: ProfileApplicationService
    private let profileRepository: ProfileRepository
    
    init(profileApplicationService: ProfileApplicationService, profileRepository: ProfileRepository) {
        self.profileApplicationService = profileApplicationService
        self.profileRepository = profileRepository
    }
    
    func initTimer() async throws{
        let editModel = ProfileEditMemojiModel.emoji(emoji: "🚀")
        
        let createProfile = CreateProfile(
            name: "HG",
            description: "Hello~",
            imageType: editModel.type(),
            imageValue: editModel.value(),
            topColor: "#A8ADBAFF",
            bottomColor: "#878C96FF"
        )
        
        try await profileApplicationService.when(createProfile)
        try await profileRepository.fetchProfile()
    }
    
}

