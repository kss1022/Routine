//
//  TimerDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerDetailInteractable: Interactable, TimerRemainListener, CircularTimerListener, TimerNextSectionListener {
    var router: TimerDetailRouting? { get set }
    var listener: TimerDetailListener? { get set }
}

protocol TimerDetailViewControllable: ViewControllable {
    func addTimerRemain(_ view: ViewControllable)
    func addCircularTimer(_ view: ViewControllable)
    func addNextSection(_ view: ViewControllable)
}

final class TimerDetailRouter: ViewableRouter<TimerDetailInteractable, TimerDetailViewControllable>, TimerDetailRouting {

    private let timerRemainBuildable: TimerRemainBuildable
    private var timerRemainRouter: Routing?
    
    private let circularTimerBuildable: CircularTimerBuildable
    private var circularTimerRouter: Routing?
    
    private let timerNextSectionBuildable: TimerNextSectionBuildable
    private var timerNextSectionRouter: Routing?
    
    init(
        interactor: TimerDetailInteractable,
        viewController: TimerDetailViewControllable,
        timerRemainBuildable: TimerRemainBuildable,
        circularTimerBuildable: CircularTimerBuildable,
        timerNextSectionBuildable: TimerNextSectionBuildable
    ) {
        self.timerRemainBuildable = timerRemainBuildable
        self.circularTimerBuildable = circularTimerBuildable
        self.timerNextSectionBuildable =  timerNextSectionBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerRemian() {
        if timerRemainRouter != nil{
            return
        }
        
        let router = timerRemainBuildable.build(withListener: interactor)
        viewController.addTimerRemain(router.viewControllable)
        
        timerRemainRouter = router
        attachChild(router)
    }
    
    func attachCircularTimer() {
        if circularTimerRouter != nil{
            return
        }
        
        let router = circularTimerBuildable.build(withListener: interactor)
        viewController.addCircularTimer(router.viewControllable)
        
        circularTimerRouter = router
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
