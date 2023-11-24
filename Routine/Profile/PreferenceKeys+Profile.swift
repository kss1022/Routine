//
//  PreferenceKeys+Profile.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation



extension PreferenceKeys{
    var showsProfileTutorial : PrefKey<Bool>{ .init(name: "kShowsProfileTutorial") }
    
    var profileSetup: PrefKey<Bool>{ .init(name: "kOrofileSetup")}
}
