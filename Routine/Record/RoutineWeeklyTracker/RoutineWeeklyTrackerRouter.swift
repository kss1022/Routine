//
//  RoutineWeeklyTrackerRouter.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol RoutineWeeklyTrackerInteractable: Interactable, RoutineWeeklyTableListener {
    var router: RoutineWeeklyTrackerRouting? { get set }
    var listener: RoutineWeeklyTrackerListener? { get set }
}

protocol RoutineWeeklyTrackerViewControllable: ViewControllable {
    func setWeeklyTable(_ view: ViewControllable)
}

final class RoutineWeeklyTrackerRouter: ViewableRouter<RoutineWeeklyTrackerInteractable, RoutineWeeklyTrackerViewControllable>, RoutineWeeklyTrackerRouting {

    private let routineWeeklyTableBuildable: RoutineWeeklyTableBuildable
    private var routineWeeklyTableRouting: Routing?
    
    
    init(
        interactor: RoutineWeeklyTrackerInteractable,
        viewController: RoutineWeeklyTrackerViewControllable,
        routineWeeklyTableBuildable: RoutineWeeklyTableBuildable
    ) {
        self.routineWeeklyTableBuildable = routineWeeklyTableBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachRoutineWeeklyTable() {
        if routineWeeklyTableRouting != nil{
            return
        }
        
        let router = routineWeeklyTableBuildable.build(withListener: interactor)
        viewController.setWeeklyTable(router.viewControllable)
        
        routineWeeklyTableRouting = router
        attachChild(router)
    }
    
}
