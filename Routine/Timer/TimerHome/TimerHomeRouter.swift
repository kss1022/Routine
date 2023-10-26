//
//  TimerHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol TimerHomeInteractable: Interactable, CreateTimerListener, TimerDetailListener, TimerSelectListener {
    var router: TimerHomeRouting? { get set }
    var listener: TimerHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol TimerHomeViewControllable: ViewControllable {
}

final class TimerHomeRouter: ViewableRouter<TimerHomeInteractable, TimerHomeViewControllable>, TimerHomeRouting {

    

    private let createTimerBuildable: CreateTimerBuildable
    private var createTimerRouting: Routing?
    
    private let timerSectionBuildable: TimerSectionBuildable
    private var timerSectionRouting: Routing?
    
    private let timerSelectBuildable: TimerSelectBuildable
    private var timerSelectRouting: Routing?
    
    
    init(
        interactor: TimerHomeInteractable,
        viewController: TimerHomeViewControllable,
        creatTimerBuildable: CreateTimerBuildable,
        timerSectionBuildable: TimerSectionBuildable,
        timerSelectBuildable: TimerSelectBuildable
    ) {
        self.createTimerBuildable = creatTimerBuildable
        self.timerSectionBuildable = timerSectionBuildable
        self.timerSelectBuildable = timerSelectBuildable
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
        viewController.dismiss(completion: nil)
        detachChild(router)
        createTimerRouting = nil
    }
    
    func attachTimerSection() {
        if timerSectionRouting != nil{
            return
        }
        
        let router = timerSectionBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        timerSectionRouting = router
        attachChild(router)
    }
    
    func detachTimerSection() {
        guard let router = timerSelectRouting else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        timerSectionRouting = nil
    }
    
    func attachSelectTimer() {
        if timerSelectRouting != nil{
            return
        }
        
        let router = timerSelectBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()
        
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        timerSelectRouting = router
        attachChild(router)
    }
    
    func detachSelectTimer() {
        guard let router = timerSelectRouting else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        timerSelectRouting = nil
    }

}
