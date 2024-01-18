//
//  TabataTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol TabataTimerInteractable: Interactable, TabataProgressListener, TabataRoundTimerListener, TimerNextSectionListener {
    var router: TabataTimerRouting? { get set }
    var listener: TabataTimerListener? { get set }
}

protocol TabataTimerViewControllable: ViewControllable {
    func addTimerRemain(_ view: ViewControllable)
    func addRoundTimer(_ view: ViewControllable)
    func addNextSection(_ view: ViewControllable)
}

final class TabataTimerRouter: ViewableRouter<TabataTimerInteractable, TabataTimerViewControllable>, TabataTimerRouting {
    
    private let tabataProgressBuildable: TabataProgressBuildable
    private var tabataProgressRouter: Routing?
    
    private let tabataRoundTimerBuildable: TabataRoundTimerBuildable
    private var tabataRoundTimerRouter: Routing?
    
    private let timerNextSectionBuildable: TimerNextSectionBuildable
    private var timerNextSectionRouter: Routing?

    
    init(
        interactor: TabataTimerInteractable,
        viewController: TabataTimerViewControllable,
        tabataProgressBuildable: TabataProgressBuildable,
        tabataRoundTimerBuildable: TabataRoundTimerBuildable,
        timerNextSectionBuildable: TimerNextSectionBuildable
    ) {
        self.tabataProgressBuildable = tabataProgressBuildable
        self.tabataRoundTimerBuildable = tabataRoundTimerBuildable
        self.timerNextSectionBuildable =  timerNextSectionBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachTabataProgress() {
        if tabataProgressRouter != nil{
            return
        }
        
        let router = tabataProgressBuildable.build(withListener: interactor)
        viewController.addTimerRemain(router.viewControllable)
        
        tabataProgressRouter = router
        attachChild(router)
    }
    
    func attachTabataRoundTimer() {
        if tabataRoundTimerRouter != nil{
            return
        }
        
        let router = tabataRoundTimerBuildable.build(withListener: interactor)
        viewController.addRoundTimer(router.viewControllable)
        
        tabataRoundTimerRouter = router
        attachChild(router)
    }
    
    func attachTimerNextSection() {
        if timerNextSectionRouter != nil{
            return
        }
        
        let router = timerNextSectionBuildable.build(withListener: interactor)
        viewController.addNextSection(router.viewControllable)
        
        timerNextSectionRouter = router
        attachChild(router)
    }
    

}
