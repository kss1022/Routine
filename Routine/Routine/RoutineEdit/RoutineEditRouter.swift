//
//  RoutineEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import ModernRIBs

protocol RoutineEditInteractable: Interactable, RoutineEditTitleListener{
    var router: RoutineEditRouting? { get set }
    var listener: RoutineEditListener? { get set }
}

protocol RoutineEditViewControllable: ViewControllable{
    func addTitle(_ view: ViewControllable)
}

final class RoutineEditRouter: ViewableRouter<RoutineEditInteractable, RoutineEditViewControllable>, RoutineEditRouting {

    private let routineEditTitleBuildable: RoutineEditTitleBuildable
    private var routineEditTitleRouting: Routing?
    
    init(
        interactor: RoutineEditInteractable,
        viewController: RoutineEditViewControllable,
        routineEditTitleBuildable: RoutineEditTitleBuildable
    ) {
        self.routineEditTitleBuildable = routineEditTitleBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachRoutingTitle() {
        if routineEditTitleRouting != nil{
            return
        }
        
        let router = routineEditTitleBuildable.build(withListener: interactor)
        viewController.addTitle(router.viewControllable)
        
        routineEditTitleRouting = router
        attachChild(router)
    }
    
    
}
