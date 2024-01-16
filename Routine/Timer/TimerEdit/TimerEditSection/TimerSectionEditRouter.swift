//
//  TimerSectionEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditInteractable: Interactable, TimerSectionEditTitleListener, TimerSectionEditTimeListener, TimerSectionEditRepeatListener {
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
    
    private let timerSectionEditTimeBuildable: TimerSectionEditTimeBuildable
    private var timerSectionEditTimeRouting: Routing?
    
    private let timerSectionEditRepeatBuildable: TimerSectionEditRepeatBuildable
    private var timerSectionEditRepeatRouting: Routing?
    
    init(
        interactor: TimerSectionEditInteractable,
        viewController: TimerSectionEditViewControllable,
        timerSectionEditTitleBuildable: TimerSectionEditTitleBuildable,
        timerSectionEditTimeBuildable: TimerSectionEditTimeBuildable,
        timerSectionEditRepeatBuildable: TimerSectionEditRepeatBuildable
    ) {
        self.timerSectionEditTitleBuildable = timerSectionEditTitleBuildable
        self.timerSectionEditTimeBuildable = timerSectionEditTimeBuildable
        self.timerSectionEditRepeatBuildable = timerSectionEditRepeatBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerSectionEditTitle(emoji: String, name: String, description: String) {
        if timerSectionEditTitleRouting != nil{
            return
        }
        
        let router = timerSectionEditTitleBuildable.build(
            withListener: interactor,
            emoji: emoji,
            name: name,
            description: description
        )
        viewController.addEditTitle(view: router.viewControllable)
        
        timerSectionEditTitleRouting = router
        attachChild(router)
    }
    
    
    func attachTimerSectionEditTime(min: Int, sec: Int) {
        if timerSectionEditTimeRouting != nil{
            return
        }
        
        let router = timerSectionEditTimeBuildable.build(withListener: interactor, min: min, sec: sec)
        viewController.addCountdown(view: router.viewControllable)
        
        timerSectionEditTimeRouting = router
        attachChild(router)
    }
    
    func attachTimerSectionEditRepeat(repeat: Int) {
        if timerSectionEditRepeatRouting != nil{
            return
        }
        
        let router = timerSectionEditRepeatBuildable.build(withListener: interactor, repeat: `repeat`)
        viewController.addCountdown(view: router.viewControllable)
        
        timerSectionEditRepeatRouting = router
        attachChild(router)
    }
}
