//
//  TimerDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerDetailInteractable: Interactable, CircularTimerListener, TimerNextSectionListener {
    var router: TimerDetailRouting? { get set }
    var listener: TimerDetailListener? { get set }
}

protocol TimerDetailViewControllable: ViewControllable {
    func addCircularTimer(_ view: ViewControllable)
    func addNextSection(_ view: ViewControllable)
}

final class TimerDetailRouter: ViewableRouter<TimerDetailInteractable, TimerDetailViewControllable>, TimerDetailRouting {

    private let circularTimerBuildable: CircularTimerBuildable
    private var circularTimerRouter: Routing?
    
    private let timerNextSectionBuildable: TimerNextSectionBuildable
    private var timerNextSectionRouter: Routing?
    
    init(
        interactor: TimerDetailInteractable,
        viewController: TimerDetailViewControllable,
        circularTimerBuildable: CircularTimerBuildable,
        timerNextSectionBuildable: TimerNextSectionBuildable
    ) {
        self.circularTimerBuildable = circularTimerBuildable
        self.timerNextSectionBuildable =  timerNextSectionBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
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
