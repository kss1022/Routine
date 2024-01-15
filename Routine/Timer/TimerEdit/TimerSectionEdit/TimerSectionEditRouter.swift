//
//  TimerSectionEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditInteractable: Interactable, TimerSectionEditTitleListener, TimerSectionEditValueListener {
    var router: TimerSectionEditRouting? { get set }
    var listener: TimerSectionEditListener? { get set }
}

protocol TimerSectionEditViewControllable: ViewControllable {
    func addEditTitle(view: ViewControllable)
    func addCountdown(view: ViewControllable)
}

final class TimerSectionEditRouter: ViewableRouter<TimerSectionEditInteractable, TimerSectionEditViewControllable>, TimerSectionEditRouting {

    private let timerSectionEditTitleBuildable: TimerSectionEditTitleBuildable
    private var timerSectionEditTitleRouting: Routing?
    
    private let timerEditSectionValueBuildable: TimerSectionEditValueBuildable
    private var timerEditCountdownRouting: Routing?
    
    init(
        interactor: TimerSectionEditInteractable,
        viewController: TimerSectionEditViewControllable,
        timerSectionEditTitleBuildable: TimerSectionEditTitleBuildable,
        timerSectionEditValueBuildable: TimerSectionEditValueBuildable
    ) {
        self.timerSectionEditTitleBuildable = timerSectionEditTitleBuildable
        self.timerEditSectionValueBuildable = timerSectionEditValueBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerSectionEditTitle() {
        if timerSectionEditTitleRouting != nil{
            return
        }
        
        let router = timerSectionEditTitleBuildable.build(withListener: interactor)
        viewController.addEditTitle(view: router.viewControllable)
        
        timerSectionEditTitleRouting = router
        attachChild(router)
    }
    
    func attachTimerEditCountDown() {
        if timerEditCountdownRouting != nil{
            return
        }
        
        let router = timerEditSectionValueBuildable.build(withListener: interactor)
        viewController.addCountdown(view: router.viewControllable)
        
        timerEditCountdownRouting = router
        attachChild(router)
    }
}
