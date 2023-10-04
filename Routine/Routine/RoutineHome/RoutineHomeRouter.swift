//
//  RoutineHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol RoutineHomeInteractable: Interactable , RoutineDetailListener, CreateRoutineListener, RoutineListListener{
    var router: RoutineHomeRouting? { get set }
    var listener: RoutineHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol RoutineHomeViewControllable: ViewControllable {
    func addRoutineList(_ view: ViewControllable)
}

final class RoutineHomeRouter: ViewableRouter<RoutineHomeInteractable, RoutineHomeViewControllable>, RoutineHomeRouting {

    
    private let createRoutineBuildable: CreateRoutineBuildable
    private var createRoutineRouting: Routing?
    
    private let routineDetailBuildable: RoutineDetailBuildable
    private var routineDetailRouting: Routing?
    
    
    private let routineListBuildable: RoutineListBuildable
    private var routineListRouting: Routing?
    
    init(
        interactor: RoutineHomeInteractable,
        viewController: RoutineHomeViewControllable,
        routineDetailBuildable: RoutineDetailBuildable,
        createRoutineBuildable: CreateRoutineBuildable,
        routineListBuildable: RoutineListBuildable
    ) {
        self.routineDetailBuildable = routineDetailBuildable
        self.createRoutineBuildable = createRoutineBuildable
        self.routineListBuildable = routineListBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachCreateRoutine() {
        if createRoutineRouting != nil{
            return
        }
        
        let router = createRoutineBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.setLargeTitle()

        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        createRoutineRouting = router
        attachChild(router)
    }
    
    func detachCreateRoutine() {
        guard let router = createRoutineRouting else {
          return
        }
                
        detachChild(router)
        createRoutineRouting = nil
    }
    
    
    func attachRoutineList() {
        if routineListRouting != nil{
            return
        }
        
        let router = routineListBuildable.build(withListener: interactor)
        viewController.addRoutineList(router.viewControllable)
        self.routineListRouting = router
        attachChild(router)
    }
    
    func attachRoutineDetail(routineId: UUID) {
        if routineDetailRouting != nil{
            return
        }
        
        let router = routineDetailBuildable.build(withListener: interactor, routineId: routineId)
        viewController.pushViewController(router.viewControllable, animated: true)
        self.routineDetailRouting = router
        attachChild(router)
    }
    
    func detachRoutineDetail() {
        guard let router = routineDetailRouting else { 
            return
        }
        
        detachChild(router)
        self.routineDetailRouting = nil
    }
    
}
