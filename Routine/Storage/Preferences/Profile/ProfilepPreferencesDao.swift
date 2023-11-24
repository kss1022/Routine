//
//  ProfilepPreferencesDao.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation




final class ProfilepPreferencesDao: ProfileDao{

    
    
    
    private let preferenceStorage: PreferenceStorage
    
    init(preferenceStorage: PreferenceStorage){
        self.preferenceStorage = preferenceStorage
    }
    
    func save(dto: ProfileDto) throws {
        preferenceStorage.profile = dto
    }
    
    func update(dto: ProfileDto) throws {
        preferenceStorage.profile = dto
    }
    
    func find() throws -> ProfileDto? {
        preferenceStorage.profile
    }
}



fileprivate extension PreferenceKeys{
    var profile: PrefKey<ProfileDto?>{ .init(name: "kProfile", defaultValue: nil)}
}
