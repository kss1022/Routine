//
//  RecordHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeInteractable: Interactable, RoutineTopAcheiveListener, RoutineWeeklyTrackerListener, RecordRoutineListDetailListener, RecordTimerListDetailListener, RoutineDataListener, TimerDataListener, RecordBannerListener, RecordRoutineListListener, RecordTimerListListener {
    var router: RecordHomeRouting? { get set }
    var listener: RecordHomeListener? { get set }
}

protocol RecordHomeViewControllable: ViewControllable {
    func setBanner(_ view: ViewControllable)
    func setRoutineList(_ view: ViewControllable)
    func setTimerList(_ view: ViewControllable)
}

final class RecordHomeRouter: ViewableRouter<RecordHomeInteractable, RecordHomeViewControllable>, RecordHomeRouting {
    
    private let routineTopAcheiveBuildable: RoutineTopAcheiveBuildable
    private var routineTopAcheiveRouting: Routing?
    
    private let routineWeeklyTrackerBuildable: RoutineWeeklyTrackerBuildable
    private var routineWeeklyTrackerRouting: Routing?
    
    private let recordRoutineListDetailBuildable: RecordRoutineListDetailBuildable
    private var recordRoutineListDetailRouting: Routing?
        
    private let recordTimerListDetailBuildable: RecordTimerListDetailBuildable
    private var recordTimerListDetailRouting: Routing?

    private let routineDataBuildable: RoutineDataBuildable
    private var routineDataRouting: Routing?
    
    private let timerDataBuildable: TimerDataBuildable
    private var timerDataRouting: Routing?
    
    private let recordBannerBuildable: RecordBannerBuildable
    private var recordBannerRouting: Routing?

    private let recordRoutineListBuildable: RecordRoutineListBuildable
    private var recordRoutineListRouting: Routing?
    
    private let recordTimerListBuildable: RecordTimerListBuildable
    private var recordTimerListRouting: Routing?
    
    
    init(
        interactor: RecordHomeInteractable,
        viewController: RecordHomeViewControllable,
        routineTopAcheiveBuildable: RoutineTopAcheiveBuildable,
        routineWeeklyTrackerBuildable: RoutineWeeklyTrackerBuildable,
        recordRoutineListDetailBuildable: RecordRoutineListDetailBuildable,
        recordTimerListDetailBuildable: RecordTimerListDetailBuildable,
        routineDataBuildable: RoutineDataBuildable,
        timerDataBuildable: TimerDataBuildable,
        recordBannerBuildable: RecordBannerBuildable,
        recordRoutineListBuildable: RecordRoutineListBuildable,
        recordTimerListBuildable: RecordTimerListBuildable
    ) {
        self.routineTopAcheiveBuildable = routineTopAcheiveBuildable
        self.routineWeeklyTrackerBuildable = routineWeeklyTrackerBuildable
        self.recordRoutineListDetailBuildable = recordRoutineListDetailBuildable
        self.recordTimerListDetailBuildable =  recordTimerListDetailBuildable
        self.routineDataBuildable = routineDataBuildable
        self.timerDataBuildable = timerDataBuildable
        self.recordBannerBuildable = recordBannerBuildable
        self.recordRoutineListBuildable = recordRoutineListBuildable
        self.recordTimerListBuildable = recordTimerListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachRoutineTopAcheive() {
        if routineTopAcheiveRouting != nil{
            return
        }
        
        let router = routineTopAcheiveBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        routineTopAcheiveRouting = router
        attachChild(router)
    }
    
    func detachRoutineTopAcheive() {
        guard let router = routineTopAcheiveRouting else { return }
        
        detachChild(router)
        routineTopAcheiveRouting = nil
    }
    
    func attachRoutineWeeklyTracker() {
        if routineWeeklyTrackerRouting != nil{
            return
        }
        
        let router = routineWeeklyTrackerBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        routineWeeklyTrackerRouting = router
        attachChild(router)
    }
    
    func detachRoutineWeeklyTracker() {
        guard let router = routineWeeklyTrackerRouting else { return }
        
        detachChild(router)
        routineWeeklyTrackerRouting = nil
    }
    
    func attachRecordRoutineListDetail() {
        if recordRoutineListDetailRouting != nil{
            return
        }
        
        let router = recordRoutineListDetailBuildable.build(withListener: interactor)        
        viewController.pushViewController(router.viewControllable, animated: true)
        
        recordRoutineListDetailRouting = router
        attachChild(router)
    }
    
    func detachRecordRoutineListDetail() {
        guard let router = recordRoutineListDetailRouting else { return }
        
        detachChild(router)
        recordRoutineListDetailRouting = nil
    }
    
    
    func attachRecordTimerListDetail() {
        if recordTimerListDetailRouting != nil{
            return
        }
        
        let router = recordTimerListDetailBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        recordTimerListDetailRouting = router
        attachChild(router)
    }
    
    func detachRecrodTimerListDetail() {
        guard let router = recordTimerListDetailRouting else { return }
        
        detachChild(router)
        recordTimerListDetailRouting = nil
    }
    
    func attachRoutineData() {
        if routineDataRouting != nil{
            return
        }
        
        let router = routineDataBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        routineDataRouting = router
        attachChild(router)
    }
    
    func detachRoutineData() {
        guard let router = routineDataRouting else { return }
        
        detachChild(router)
        routineDataRouting = nil
    }
    
    
    func attachTimerData() {
        if timerDataRouting != nil{
            return
        }
        
        let router = timerDataBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        timerDataRouting = router
        attachChild(router)
    }
    
    func detachTimerData() {
        guard let router = timerDataRouting else { return }
        
        detachChild(router)
        timerDataRouting = nil
    }
    
    func attachRecordBanner() {
        if recordBannerRouting != nil{
            return
        }
        
        let router = recordBannerBuildable.build(withListener: interactor)
        viewController.setBanner(router.viewControllable)
        
        recordBannerRouting = router
        attachChild(router)
    }
    
    func attachRecordRoutineList() {
        if recordRoutineListRouting != nil{
            return
        }
        
        let router = recordRoutineListBuildable.build(withListener: interactor)
        viewController.setRoutineList(router.viewControllable)
        
        recordRoutineListRouting = router
        attachChild(router)
    }
    
    
    func attachRecordTimerList() {
        if recordTimerListRouting != nil{
            return
        }
        
        let router = recordTimerListBuildable.build(withListener: interactor)
        viewController.setTimerList(router.viewControllable)
        
        recordTimerListRouting = router
        attachChild(router)
    }

    
}
