//
//  AddYourTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddYourTimerRouting: Routing {
    func cleanupViews()
    
    func attachAddFocusTimer()
    func detachAddFocusTimer(dismiss: Bool)
    
    func attachAddTabataTimer()
    func detachAddTabataTimer(dismiss: Bool)
    
    func attachAddRoundTimer()
    func detachAddRoundTimer(dismiss: Bool)
}

protocol AddYourTimerListener: AnyObject {
    func addYourTimerDidClose()
    func addYourTimerDidAddNewTimer()
}

protocol AddYourTimerInteractorDependency{
    var timerType: AddTimerType{ get }
}

final class AddYourTimerInteractor: Interactor, AddYourTimerInteractable, AdaptivePresentationControllerDelegate {

    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    weak var router: AddYourTimerRouting?
    weak var listener: AddYourTimerListener?

    private let dependency: AddYourTimerInteractorDependency
    
    // in constructor.
    init(
        dependency: AddYourTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        switch dependency.timerType {
        case .focus: router?.attachAddFocusTimer()
        case .tabata: router?.attachAddTabataTimer()
        case .round: router?.attachAddRoundTimer()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        switch dependency.timerType {
        case .focus:
            router?.detachAddFocusTimer(dismiss: false)
            listener?.addYourTimerDidClose()
        case .tabata:
            router?.detachAddTabataTimer(dismiss: false)
            listener?.addYourTimerDidClose()
        case .round: 
            router?.detachAddRoundTimer(dismiss: false)
            listener?.addYourTimerDidClose()
        }
    }
    
    //MARK: AddFocusTimer
    func addFocusTimerCloseButtonDidTap() {
        router?.detachAddFocusTimer(dismiss: true)
        listener?.addYourTimerDidClose()
    }
    
    func addfocusTimerDidAddNewTimer() {
        router?.detachAddFocusTimer(dismiss: false)
        listener?.addYourTimerDidAddNewTimer()
    }
    
    //MARK: AddTabataTimer
    func addTabataTimerCloseButtonDidTap() {
        router?.detachAddTabataTimer(dismiss: true)
        listener?.addYourTimerDidClose()
    }
    
    func addTabataTimerDidAddNewTimer() {
        router?.detachAddTabataTimer(dismiss: false)
        listener?.addYourTimerDidAddNewTimer()
    }
    
    
    //MARK: AddRoundTimer    
    func addRoundTimerCloseButtonDidTap() {
        router?.detachAddRoundTimer(dismiss: true)
        listener?.addYourTimerDidClose()
    }
    
    func addRoundTimerDidAddNewTimer() {
        router?.detachAddRoundTimer(dismiss: false)
        listener?.addYourTimerDidClose()
        listener?.addYourTimerDidAddNewTimer()
    }
    

    
}
