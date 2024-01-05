//
//  AppTutorialInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation
import ModernRIBs

protocol AppTutorialRouting: Routing {
    func cleanupViews()
    
    func attachAppTutorialHome()
    func attachAppTutorialRoutine()
    func attachAppTutorialProfile()
    func attachAppTutorailTimer()
}

protocol AppTutorialListener: AnyObject {
    func appTutorailDidFinish()
}

final class AppTutorialInteractor: Interactor, AppTutorialInteractable{
       

    weak var router: AppTutorialRouting?
    weak var listener: AppTutorialListener?

    private let preferenceStorage: PreferenceStorage
    
    override init() {
        preferenceStorage = PreferenceStorage.shared
        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let now = Date()
        preferenceStorage.installation = now
        
        
        if !preferenceStorage.showAppTutorialHome{
            router?.attachAppTutorialHome()
            return
        }
        
        if !preferenceStorage.showAppTutorialRoutine{
            router?.attachAppTutorialRoutine()
            return
        }
        
        if !preferenceStorage.showAppTutorialProfile{
            router?.attachAppTutorialProfile()
            return
        }
        
        router?.attachAppTutorailTimer()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    
    //MARK: Tutorial Home
    func appTutorailHomeDidFinish() {
        router?.attachAppTutorialRoutine()      
        preferenceStorage.showAppTutorialHome = true
    }
    
    //MARK: Tutorial Routine
    func appTutorailRoutineDidFinish() {
        preferenceStorage.showAppTutorialRoutine = true
        router?.attachAppTutorialProfile()
    }
    
    //MARK: Tutorial Profile
    func appTutorailProfileDidFinish() {
        preferenceStorage.showAppTutorialProfile = true
        router?.attachAppTutorailTimer()
    }

    //MARK: Tutorial Timer
    func AppTutorialTimerDidFinish() {
        preferenceStorage.showAppTutorialTimer = true
        listener?.appTutorailDidFinish()
    }
    


}
