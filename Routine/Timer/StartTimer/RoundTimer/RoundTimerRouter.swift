//
//  RoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import ModernRIBs

protocol RoundTimerInteractable: Interactable, RoundProgressListener, RoundRoundTimerListener, TimerNextSectionListener {
    var router: RoundTimerRouting? { get set }
    var listener: RoundTimerListener? { get set }
}

protocol RoundTimerViewControllable: ViewControllable {
    func addTimerRemain(_ view: ViewControllable)
    func addRoundTimer(_ view: ViewControllable)
    func addNextSection(_ view: ViewControllable)
}

final class RoundTimerRouter: ViewableRouter<RoundTimerInteractable, RoundTimerViewControllable>, RoundTimerRouting {

    private let roundProgressBuildable: RoundProgressBuildable
    private var roundProgressRouter: Routing?
    
    private let roundRoundTimerBuildable: RoundRoundTimerBuildable
    private var roundRoundTimerRouter: Routing?
    
    private let timerNextSectionBuildable: TimerNextSectionBuildable
    private var timerNextSectionRouter: Routing?
    
    init(
        interactor: RoundTimerInteractable,
        viewController: RoundTimerViewControllable,
        roundProgressBuildable: RoundProgressBuildable,
        roundRoundTimerBuildable: RoundRoundTimerBuildable,
        timerNextSectionBuildable: TimerNextSectionBuildable
    ) {
        self.roundProgressBuildable = roundProgressBuildable
        self.roundRoundTimerBuildable = roundRoundTimerBuildable
        self.timerNextSectionBuildable =  timerNextSectionBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    
    func attachRoundProgress() {
        if roundProgressRouter != nil{
            return
        }
        
        let router = roundProgressBuildable.build(withListener: interactor)
        viewController.addTimerRemain(router.viewControllable)
        
        roundProgressRouter = router
        attachChild(router)
    }
    
    func attachRoundRoundTimer() {
        if roundRoundTimerRouter != nil{
            return
        }
        
        let router = roundRoundTimerBuildable.build(withListener: interactor)
        viewController.addRoundTimer(router.viewControllable)
        
        roundRoundTimerRouter = router
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
