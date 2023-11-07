//
//  RoutineDataRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataInteractable: Interactable, RoutineDataOfWeekListener, RoutineDataOfMonthListener, RoutineDataOfYearListener, RoutineTotalRecordListener  {
    var router: RoutineDataRouting? { get set }
    var listener: RoutineDataListener? { get set }
}

protocol RoutineDataViewControllable: ViewControllable {
    func setDataOfWeek(_ view: ViewControllable)
    func setDataOfMonth(_ view: ViewControllable)
    func setDataOfYear(_ view: ViewControllable)
    func setTotalRecord(_ view: ViewControllable)
    
}

final class RoutineDataRouter: ViewableRouter<RoutineDataInteractable, RoutineDataViewControllable>, RoutineDataRouting {


    private let routineDataOfWeekBuildable: RoutineDataOfWeekBuildable
    private var routineDataOfWeekRouting: Routing?
    
    private let routineDataOfMonthBuildable: RoutineDataOfMonthBuildable
    private var routineDataOfMonthRouting: Routing?
    
    private let routineDataOfYearBuildable: RoutineDataOfYearBuildable
    private var routineDataOfYearRouting: Routing?
    
    private let routineTotalRecordBuildable: RoutineTotalRecordBuildable
    private var routineTotalRecordRouting: Routing?
    
    init(
        interactor: RoutineDataInteractable,
        viewController: RoutineDataViewControllable,
        routineDataOfWeekBuildable: RoutineDataOfWeekBuildable,
        routineDataOfMonthBuildable: RoutineDataOfMonthBuildable,
        routineDataOfYearBuildable: RoutineDataOfYearBuildable,
        routineTotalRecordBuildable: RoutineTotalRecordBuildable
    ) {
        self.routineDataOfWeekBuildable = routineDataOfWeekBuildable
        self.routineDataOfMonthBuildable = routineDataOfMonthBuildable
        self.routineDataOfYearBuildable = routineDataOfYearBuildable
        self.routineTotalRecordBuildable = routineTotalRecordBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachRoutineDataOfWeek() {
        if routineDataOfWeekRouting != nil{
            return
        }
        
        let router = routineDataOfWeekBuildable.build(withListener: interactor)
        viewController.setDataOfWeek(router.viewControllable)
        
        routineDataOfWeekRouting = router
        attachChild(router)
    }
    
    func attachRoutineDataOfMonth() {
        if routineDataOfMonthRouting != nil{
            return
        }
        
        let router = routineDataOfMonthBuildable.build(withListener: interactor)
        viewController.setDataOfMonth(router.viewControllable)
        
        routineDataOfMonthRouting = router
        attachChild(router)
    }
    
    func attachRoutineDataOfYear() {
        if routineDataOfYearRouting != nil{
            return
        }
        
        let router = routineDataOfYearBuildable.build(withListener: interactor)
        viewController.setDataOfYear(router.viewControllable)
        
        routineDataOfYearRouting = router
        attachChild(router)
    }
    
    func attachRoutineTotalRecord() {
        if routineTotalRecordRouting != nil{
            return
        }
        
        let router = routineTotalRecordBuildable.build(withListener: interactor)
        viewController.setTotalRecord(router.viewControllable)
        
        routineTotalRecordRouting = router
        attachChild(router)
    }
}
