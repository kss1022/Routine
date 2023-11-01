//
//  AddFocusTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddFocusTimerInteractable: Interactable, TimerEditTitleListener, TimerEditCountdownListener {
    var router: AddFocusTimerRouting? { get set }
    var listener: AddFocusTimerListener? { get set }
}

protocol AddFocusTimerViewControllable: ViewControllable {
    func addTimeEditTitle(_ view: ViewControllable)
    func addTimerEditCountdown(_ view: ViewControllable)
}

final class AddFocusTimerRouter: ViewableRouter<AddFocusTimerInteractable, AddFocusTimerViewControllable>, AddFocusTimerRouting {

    private let timerEditTitleBuildable: TimerEditTitleBuildable
    private var timerEditTitleRouting: Routing?
    
    private let timerEditCountdownBuildable: TimerEditCountdownBuildable
    private var timerEditCountdownRouting: Routing?
    
    
    init(
        interactor: AddFocusTimerInteractable,
        viewController: AddFocusTimerViewControllable,
        timerEditTitleBuildable: TimerEditTitleBuildable,
        timerEditCountdownBuildable: TimerEditCountdownBuildable
    ) {
        self.timerEditTitleBuildable = timerEditTitleBuildable
        self.timerEditCountdownBuildable = timerEditCountdownBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerEditTitle() {
        if timerEditTitleRouting != nil{
            return
        }
        
        let router = timerEditTitleBuildable.build(withListener: interactor)
        viewController.addTimeEditTitle(router.viewControllable)
        
        timerEditTitleRouting = router
        attachChild(router)
    }
    
    func attachTimerEditCountdown() {
        if timerEditCountdownRouting != nil{
            return
        }
        
        let router = timerEditCountdownBuildable.build(withListener: interactor)
        viewController.addTimerEditCountdown(router.viewControllable)
        
        timerEditCountdownRouting = router
        attachChild(router)
    }
}
