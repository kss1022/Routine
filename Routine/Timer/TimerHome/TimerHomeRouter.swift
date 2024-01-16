//
//  TimerHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol TimerHomeInteractable: Interactable, TimerListListener, StartTimerListener, CreateTimerListener, TimerEditListener {
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
    
    private let startTimerBuildable: StartTimerBuildable
    private var startTimerRouting: Routing?
        
    private let createTimerBuildable: CreateTimerBuildable
    private var createTimerRouting: Routing?
    
    private let timerEditBuildable: TimerEditBuildable
    private var timerEditRouting: Routing?
    
    
    init(
        interactor: TimerHomeInteractable,
        viewController: TimerHomeViewControllable,
        timerListBuildable: TimerListBuildable,
        startTimerBuildable: StartTimerBuildable,
        creatTimerBuildable: CreateTimerBuildable,
        timerEditBuildable: TimerEditBuildable
    ) {
        self.timerListBuildable = timerListBuildable
        self.startTimerBuildable = startTimerBuildable
        self.createTimerBuildable = creatTimerBuildable
        self.timerEditBuildable = timerEditBuildable
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
    
    
    func attachTimerEdit(timerId: UUID) {
        if timerEditRouting != nil{
            return
        }

        let router = timerEditBuildable.build(withListener: interactor, timerId: timerId)
        timerEditRouting = router
        attachChild(router)
    }
    
    func detachTimerEdit() {
        guard let router = timerEditRouting else { return }        
        detachChild(router)
        timerEditRouting = nil
    }
    
    
}
