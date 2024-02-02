//
//  RecordRoutineListDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RecordRoutineListDetailInteractable: Interactable, RoutineDataListener{
    var router: RecordRoutineListDetailRouting? { get set }
    var listener: RecordRoutineListDetailListener? { get set }
}

protocol RecordRoutineListDetailViewControllable: ViewControllable {
}

final class RecordRoutineListDetailRouter: ViewableRouter<RecordRoutineListDetailInteractable, RecordRoutineListDetailViewControllable>, RecordRoutineListDetailRouting {

    private let routineDataBuildable: RoutineDataBuildable
    private var routineDataRouting: Routing?

    
    init(
        interactor: RecordRoutineListDetailInteractable,
        viewController: RecordRoutineListDetailViewControllable,
        routineDataBuildable: RoutineDataBuildable
    ) {
        self.routineDataBuildable = routineDataBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
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
}
