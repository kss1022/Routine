//
//  SectionTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol SectionTimerInteractable: Interactable, TimerRemainListener, SectionRoundTimerListener, TimerNextSectionListener {
    var router: SectionTimerRouting? { get set }
    var listener: SectionTimerListener? { get set }
}

protocol SectionTimerViewControllable: ViewControllable {
    func addTimerRemain(_ view: ViewControllable)
    func addRoundTimer(_ view: ViewControllable)
    func addNextSection(_ view: ViewControllable)
}

final class SectionTimerRouter: ViewableRouter<SectionTimerInteractable, SectionTimerViewControllable>, SectionTimerRouting {

    private let timerRemainBuildable: TimerRemainBuildable
    private var timerRemainRouter: Routing?
    
    private let sectionRoundTimer: SectionRoundTimerBuildable
    private var sectionRoundTimerRouter: Routing?
    
    private let timerNextSectionBuildable: TimerNextSectionBuildable
    private var timerNextSectionRouter: Routing?
    
    init(
        interactor: SectionTimerInteractable,
        viewController: SectionTimerViewControllable,
        timerRemainBuildable: TimerRemainBuildable,
        sectionRoundTimerBuildable: SectionRoundTimerBuildable,
        timerNextSectionBuildable: TimerNextSectionBuildable
    ) {
        self.timerRemainBuildable = timerRemainBuildable
        self.sectionRoundTimer = sectionRoundTimerBuildable
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
    
    func attachSectionRoundTimer() {
        if sectionRoundTimerRouter != nil{
            return
        }
        
        let router = sectionRoundTimer.build(withListener: interactor)
        viewController.addRoundTimer(router.viewControllable)
        
        sectionRoundTimerRouter = router
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
