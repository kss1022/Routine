//
//  AddFocusTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddFocusTimerInteractable: Interactable, TimerEditTitleListener, TimerEditMinutesListener {
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
    
    private let timerEditMinutesBuildable: TimerEditMinutesBuildable
    private var timerEditMinutesRouting: Routing?
    
    
    init(
        interactor: AddFocusTimerInteractable,
        viewController: AddFocusTimerViewControllable,
        timerEditTitleBuildable: TimerEditTitleBuildable,
        timerEditMinutesBuildable: TimerEditMinutesBuildable
    ) {
        self.timerEditTitleBuildable = timerEditTitleBuildable
        self.timerEditMinutesBuildable = timerEditMinutesBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerEditTitle(name: String, emoji: String) {
        if timerEditTitleRouting != nil{
            return
        }
        
        let router = timerEditTitleBuildable.build(withListener: interactor, name: name, emoji: emoji)
        viewController.addTimeEditTitle(router.viewControllable)
        
        timerEditTitleRouting = router
        attachChild(router)
    }
    
    func attachTimerEditMinutes(minutes: Int) {
        if timerEditMinutesRouting != nil{
            return
        }
        
        let router = timerEditMinutesBuildable.build(withListener: interactor, minutes: minutes)
        viewController.addTimerEditCountdown(router.viewControllable)
        
        timerEditMinutesRouting = router
        attachChild(router)
    }
}
