//
//  TimerHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeInteractable: Interactable, CreateTimerListener, TimerDetailListener,TimerListListener {
    var router: TimerHomeRouting? { get set }
    var listener: TimerHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol TimerHomeViewControllable: ViewControllable {
    func setList(_ view: ViewControllable)
}

final class TimerHomeRouter: ViewableRouter<TimerHomeInteractable, TimerHomeViewControllable>, TimerHomeRouting {

    private let createTimerBuildable: CreateTimerBuildable
    private var createTimerRouting: Routing?
    
    private let timerDetailBuildable: TimerDetailBuildable
    private var timerDetailRouting: Routing?
    
    private let timerListBuildable: TimerListBuildable
    private var timerListRouting: Routing?
    
    init(
        interactor: TimerHomeInteractable,
        viewController: TimerHomeViewControllable,
        creatTimerBuildable: CreateTimerBuildable,
        timerDetailBuildable: TimerDetailBuildable,
        timerListBuildable: TimerListBuildable
    ) {
        self.createTimerBuildable = creatTimerBuildable
        self.timerDetailBuildable = timerDetailBuildable
        self.timerListBuildable = timerListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
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
     
        detachChild(router)
        createTimerRouting = nil
    }
    
    func attachTimerDetail() {
        if timerDetailRouting != nil{
            return
        }
        
        let router = timerDetailBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        timerDetailRouting = router
        attachChild(router)
    }
    
    func detachTimerDetail() {
        guard let router = timerDetailRouting else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        timerDetailRouting = nil
    }
    
    func attachTimerList() {
        if timerListRouting != nil{
            return
        }
        
        let router = timerListBuildable.build(withListener: interactor)
        viewController.setList(router.viewControllable)
        
        self.timerListRouting = router
        attachChild(router)
    }
}
