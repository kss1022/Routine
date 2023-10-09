//
//  RoutineHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol RoutineHomeInteractable: Interactable , RoutineDetailListener, CreateRoutineListener, RoutineWeekCalenderListener, RoutineListListener{
    var router: RoutineHomeRouting? { get set }
    var listener: RoutineHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol RoutineHomeViewControllable: ViewControllable {
    func addRoutineWeekCalender(_ view: ViewControllable)
    func addRoutineList(_ view: ViewControllable)
}

final class RoutineHomeRouter: ViewableRouter<RoutineHomeInteractable, RoutineHomeViewControllable>, RoutineHomeRouting {

    
    private let createRoutineBuildable: CreateRoutineBuildable
    private var createRoutineRouting: Routing?
    
    private let routineDetailBuildable: RoutineDetailBuildable
    private var routineDetailRouting: Routing?
    
    private let routineWeekCalenderBuildable: RoutineWeekCalenderBuildable
    private var routineWeekCalenderRouting: Routing?
    
    private let routineListBuildable: RoutineListBuildable
    private var routineListRouting: Routing?
    
    
    init(
        interactor: RoutineHomeInteractable,
        viewController: RoutineHomeViewControllable,
        routineDetailBuildable: RoutineDetailBuildable,
        createRoutineBuildable: CreateRoutineBuildable,
        routineWeekCalenderBuildable: RoutineWeekCalenderBuildable,
        routineListBuildable: RoutineListBuildable
    ) {
        self.routineDetailBuildable = routineDetailBuildable
        self.createRoutineBuildable = createRoutineBuildable
        self.routineWeekCalenderBuildable = routineWeekCalenderBuildable
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
    
    func detachCreateRoutine(dismiss: Bool) {
        guard let router = createRoutineRouting else {
          return
        }
        
        if dismiss{
            viewController.dismiss(completion: nil)
        }
                
        detachChild(router)
        createRoutineRouting = nil
    }
    
    
    func attachRoutineWeekCalender() {
        if routineWeekCalenderRouting != nil{
            return
        }
        
        let router = routineWeekCalenderBuildable.build(withListener: interactor)
        viewController.addRoutineWeekCalender(router.viewControllable)
        self.routineWeekCalenderRouting = router
        attachChild(router)
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
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        self.routineDetailRouting = router
        attachChild(router)
    }
    
    func detachRoutineDetail(dismiss: Bool) {
        guard let router = routineDetailRouting else {
            return
        }
        
        if dismiss{
            viewController.dismiss(completion: nil)
        }
        
        detachChild(router)
        self.routineDetailRouting = nil
    }
    
}
