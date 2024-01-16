//
//  EditFocusTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import ModernRIBs

protocol EditFocusTimerInteractable: Interactable, TimerEditTitleListener, TimerEditMinutesListener {
    var router: EditFocusTimerRouting? { get set }
    var listener: EditFocusTimerListener? { get set }
}

protocol EditFocusTimerViewControllable: ViewControllable {
    func addTimeEditTitle(_ view: ViewControllable)
    func addTimerEditCountdown(_ view: ViewControllable)
}

final class EditFocusTimerRouter: ViewableRouter<EditFocusTimerInteractable, EditFocusTimerViewControllable>, EditFocusTimerRouting {
    
    private let timerEditTitleBuildable: TimerEditTitleBuildable
    private var timerEditTitleRouting: Routing?
    
    private let timerEditMinutesBuildable: TimerEditMinutesBuildable
    private var timerEditMinutesRouting: Routing?
    
    init(
        interactor: EditFocusTimerInteractable,
        viewController: EditFocusTimerViewControllable,
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
