//
//  RoutineDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineDetailInteractable: Interactable , RoutineTitleListener{
    var router: RoutineDetailRouting? { get set }
    var listener: RoutineDetailListener? { get set }
}

protocol RoutineDetailViewControllable: ViewControllable {
    func addTitle(_ view: ViewControllable)
}

final class RoutineDetailRouter: ViewableRouter<RoutineDetailInteractable, RoutineDetailViewControllable>, RoutineDetailRouting {

    private let routineTitleBuildable: RoutineTitleBuildable
    private var routineTitleRouting: Routing?
    
    init(
        interactor: RoutineDetailInteractable,
        viewController: RoutineDetailViewControllable,
        routineTitleBuildable: RoutineTitleBuildable
    ) {
        self.routineTitleBuildable = routineTitleBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachRoutineTitle() {
        if routineTitleRouting != nil{
            return
        }
        
        let router = routineTitleBuildable.build(withListener: interactor)
        viewController.addTitle(router.viewControllable)
        
        self.routineTitleRouting = router
        attachChild(router)
    }
}
