//
//  TimerDataRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataInteractable: Interactable, TimerDataOfYearListener, TimerDataOfStatsListener, TimerTotalRecordListener {
    var router: TimerDataRouting? { get set }
    var listener: TimerDataListener? { get set }
}

protocol TimerDataViewControllable: ViewControllable {
    func setDataOfYear(_ view: ViewControllable)
    func setDataOfStas(_ view: ViewControllable)
    func setTotalRecord(_ view: ViewControllable)
}

final class TimerDataRouter: ViewableRouter<TimerDataInteractable, TimerDataViewControllable>, TimerDataRouting {

    
    private let timerDataOfYearBuildable: TimerDataOfYearBuildable
    private var timerDataOfYearRouting: Routing?
    
    private let timerDataOfStatsBuildable: TimerDataOfStatsBuildable
    private var timerDataOfStatsRouting: Routing?
    
    private let timerTotalRecordBuildable: TimerTotalRecordBuildable
    private var timerTotalRecordRouting: Routing?
    
    init(
        interactor: TimerDataInteractable,
        viewController: TimerDataViewControllable,
        timerDataOfYearBuildable: TimerDataOfYearBuildable,
        timerDataOfStatsBuildable: TimerDataOfStatsBuildable,
        timerTotalRecordBuildable: TimerTotalRecordBuildable
    ) {
        self.timerDataOfYearBuildable = timerDataOfYearBuildable
        self.timerDataOfStatsBuildable = timerDataOfStatsBuildable
        self.timerTotalRecordBuildable = timerTotalRecordBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTimerDataOfYear() {
        if timerDataOfYearRouting != nil{
            return
        }
        
        let router = timerDataOfYearBuildable.build(withListener: interactor)
        viewController.setDataOfYear(router.viewControllable)
        
        
        timerDataOfYearRouting = router
        attachChild(router)
    }
    
    func attachTimerDatOfStats() {
        if timerDataOfStatsRouting != nil{
            return
        }
        
        let router = timerDataOfStatsBuildable.build(withListener: interactor)
        viewController.setDataOfStas(router.viewControllable)
        
        timerDataOfStatsRouting = router
        attachChild(router)
    }

    func attachTimerTotalRecord() {
        if timerTotalRecordRouting != nil{
            return
        }
        
        let router = timerTotalRecordBuildable.build(withListener: interactor)
        viewController.setTotalRecord(router.viewControllable)
        
        timerTotalRecordRouting = router
        attachChild(router)
    }

}
