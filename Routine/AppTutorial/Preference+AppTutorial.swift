//
//  PreferKeys+AppTutorial.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import Foundation



extension PreferenceKeys{
    var showAppTutorials: PrefKey<Bool>{ .init(name: "showAppTutorials")}
    
    var showAppTutorialHome: PrefKey<Bool>{ .init(name: "kShowAppTutorialHome")}
    var showAppTutorialRoutine: PrefKey<Bool>{ .init(name: "kShowAppTutorialRoutine")}
    var showAppTutorialProfile: PrefKey<Bool>{ .init(name: "kShowAppTutorialProfile")}
    var showAppTutorialTimer: PrefKey<Bool>{ .init(name: "kShowAppTutorialTimer")}
}
