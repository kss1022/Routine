//
//  ProfileProjection.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import Combine


final class ProfileProjection{
    
    private var profileDao: ProfileDao!
    
    private var cancellables: Set<AnyCancellable>
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        profileDao = dbManager.profileDao
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        DomainEventPublihser.share
            .onReceive(ProfileCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(ProfileUpdated.self, action: when)
            .store(in: &cancellables)
    }
    
    private func when(event: ProfileCreated){
        do{
            let dto = ProfileDto(
                profileId: event.profileId.id,
                profileName: event.profileName.name,
                profileIntroduction: event.profileIntroduction.introduction,
                profileImage: event.profileImage,
                profileStyle: event.profileStyle
            )
            
            try profileDao.save(dto: dto)
        }catch{
            Log.e("EventHandler Error: RoutineCreated \(error)")
        }
    }
    
    
    private func when(event: ProfileUpdated){
        do{
            let dto = ProfileDto(
                profileId: event.profileId.id,
                profileName: event.profileName.name,
                profileIntroduction: event.profileIntroduction.introduction,
                profileImage: event.profileImage,
                profileStyle: event.profileStyle
            )
            
            try profileDao.update(dto: dto)
        }catch{
            Log.e("EventHandler Error: RoutineCreated \(error)")
        }
    }
    

}
