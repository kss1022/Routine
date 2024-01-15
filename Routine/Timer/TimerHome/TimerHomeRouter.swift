//
//  TimerHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol TimerHomeInteractable: Interactable, TimerListListener, CreateTimerListener, StartTimerListener {
    var router: TimerHomeRouting? { get set }
    var listener: TimerHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol TimerHomeViewControllable: ViewControllable {
    func setTimerList(_ view: ViewControllable)
}

final class TimerHomeRouter: ViewableRouter<TimerHomeInteractable, TimerHomeViewControllable>, TimerHomeRouting {

    private let timerListBuildable: TimerListBuildable
    private var timerListRouting: TimerListRouting?

    private let createTimerBuildable: CreateTimerBuildable
    private var createTimerRouting: Routing?
    
    private let startTimerBuildable: StartTimerBuildable
    private var startTimerRouting: Routing?
    
    
    init(
        interactor: TimerHomeInteractable,
        viewController: TimerHomeViewControllable,
        timerListBuildable: TimerListBuildable,
        creatTimerBuildable: CreateTimerBuildable,
        startTimerBuildable: StartTimerBuildable
    ) {
        self.timerListBuildable = timerListBuildable
        self.createTimerBuildable = creatTimerBuildable
        self.startTimerBuildable = startTimerBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachTimerList() {
        if timerListRouting != nil{
            return
        }
        
        let router = timerListBuildable.build(withListener: interactor)
        viewController.setTimerList(router.viewControllable)
        timerListRouting = router
        attachChild(router)
    }
    
    func attachCreateTimer() {
        if createTimerRouting != nil{
            return
        }
        
        let router = createTimerBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        createTimerRouting = router
        attachChild(router)
    }
    
    func detachCreateTimer() {
        guard let router = createTimerRouting else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        createTimerRouting = nil
    }
    
    
    func attachStartTimer(timerId: UUID) {
        if startTimerRouting != nil{
            return
        }
        
        let router = startTimerBuildable.build(withListener: interactor, timerId: timerId)
        startTimerRouting = router
        attachChild(router)
    }
    
    func detachStartTimer() {
        guard let router = startTimerRouting else { return }        
        detachChild(router)
        startTimerRouting = nil
    }
    
}
