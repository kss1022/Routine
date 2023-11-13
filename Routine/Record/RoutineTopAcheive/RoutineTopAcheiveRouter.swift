//
//  RoutineTopAcheiveRouter.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveInteractable: Interactable, RoutineTopAcheiveChartListener, RoutineTopAcheiveTotalRecordListener {
    var router: RoutineTopAcheiveRouting? { get set }
    var listener: RoutineTopAcheiveListener? { get set }
}

protocol RoutineTopAcheiveViewControllable: ViewControllable {
    func setTopAcheiveChart(_ view: ViewControllable)
    func setTopAchieveTotalRecord(_ view: ViewControllable)
}

final class RoutineTopAcheiveRouter: ViewableRouter<RoutineTopAcheiveInteractable, RoutineTopAcheiveViewControllable>, RoutineTopAcheiveRouting {

    private let routineTopAcheiveChartBuildable: RoutineTopAcheiveChartBuildable
    private var routineTopAcheiveRouting: Routing?
    
    private let routineTopAcheiveTotalRecordBuildable: RoutineTopAcheiveTotalRecordBuildable
    private var routineTopAcheiveTotalRecordRouting: Routing?
    
    init(
        interactor: RoutineTopAcheiveInteractable,
        viewController: RoutineTopAcheiveViewControllable,
        routineTopAcheiveChartBuildable: RoutineTopAcheiveChartBuildable,
        routineTopAcheiveTotalRecordBuildable: RoutineTopAcheiveTotalRecordBuildable
    ) {
        self.routineTopAcheiveChartBuildable = routineTopAcheiveChartBuildable
        self.routineTopAcheiveTotalRecordBuildable = routineTopAcheiveTotalRecordBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTopAcheiveChart() {
        if routineTopAcheiveRouting != nil{
            return
        }
        
        let router = routineTopAcheiveChartBuildable.build(withListener: interactor)
        viewController.setTopAcheiveChart(router.viewControllable)
        
        routineTopAcheiveRouting = router
        attachChild(router)
    }
    
    func attachTopAcheiveTotalRecord() {
        if routineTopAcheiveTotalRecordRouting != nil{
            return
        }
        
        let router = routineTopAcheiveTotalRecordBuildable.build(withListener: interactor)
        viewController.setTopAchieveTotalRecord(router.viewControllable)
        
        routineTopAcheiveTotalRecordRouting = router
        attachChild(router)
    }
    
}
