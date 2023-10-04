//
//  RoutineDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs

protocol RoutineDetailInteractable: Interactable , RoutineEditListener, RoutineTitleListener{
    var router: RoutineDetailRouting? { get set }
    var listener: RoutineDetailListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol RoutineDetailViewControllable: ViewControllable {
    func addTitle(_ view: ViewControllable)
}

final class RoutineDetailRouter: ViewableRouter<RoutineDetailInteractable, RoutineDetailViewControllable>, RoutineDetailRouting {


    private let routineEditBuildable: RoutineEditBuildable
    private var routineEditRouting: Routing?
    
    private let routineTitleBuildable: RoutineTitleBuildable
    private var routineTitleRouting: Routing?

    
    init(
        interactor: RoutineDetailInteractable,
        viewController: RoutineDetailViewControllable,
        routineEditBuildable: RoutineEditBuildable,
        routineTitleBuildable: RoutineTitleBuildable
    ) {
        self.routineEditBuildable = routineEditBuildable
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
    
    func attachRoutineEdit(routineId: UUID) {
        if routineEditRouting != nil{
            return
        }
    
        
        let router = routineEditBuildable.build(withListener: interactor, routineId: routineId)
        let navigaion = NavigationControllerable(root: router.viewControllable)
        
        navigaion.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigaion, animated: true, completion: nil)
        
        routineEditRouting = router
        attachChild(router)
    }
    
    func detachRoutineEdit(dissmiss: Bool) {
        guard let router = routineEditRouting else {
            return
        }
        
        if dissmiss{
            viewController.dismiss(completion: nil)
        }            
                
        detachChild(router)
        routineEditRouting = nil
    }

}
