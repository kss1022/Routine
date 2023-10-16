//
//  RoutineHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs
import UIKit


protocol RoutineHomeInteractable: Interactable , RoutineDetailListener, CreateRoutineListener, RoutineWeekCalendarListener, RoutineListListener{
    var router: RoutineHomeRouting? { get set }
    var listener: RoutineHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol RoutineHomeViewControllable: ViewControllable {
    func addRoutineWeekCalendar(_ view: ViewControllable)
    func addRoutineList(_ view: ViewControllable)
}

final class RoutineHomeRouter: ViewableRouter<RoutineHomeInteractable, RoutineHomeViewControllable>, RoutineHomeRouting {

    
    private let createRoutineBuildable: CreateRoutineBuildable
    private var createRoutineRouting: Routing?
    
    private let routineDetailBuildable: RoutineDetailBuildable
    private var routineDetailRouting: Routing?
    
    private let routineWeekCalendarBuildable: RoutineWeekCalendarBuildable
    private var routineWeekCalendarRouting: Routing?
    
    private let routineListBuildable: RoutineListBuildable
    private var routineListRouting: Routing?
    
    
    init(
        interactor: RoutineHomeInteractable,
        viewController: RoutineHomeViewControllable,
        routineDetailBuildable: RoutineDetailBuildable,
        createRoutineBuildable: CreateRoutineBuildable,
        routineWeekCalendarBuildable: RoutineWeekCalendarBuildable,
        routineListBuildable: RoutineListBuildable
    ) {
        self.routineDetailBuildable = routineDetailBuildable
        self.createRoutineBuildable = createRoutineBuildable
        self.routineWeekCalendarBuildable = routineWeekCalendarBuildable
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
    
    
    func attachRoutineWeekCalendar() {
        if routineWeekCalendarRouting != nil{
            return
        }
        
        let router = routineWeekCalendarBuildable.build(withListener: interactor)
        viewController.addRoutineWeekCalendar(router.viewControllable)
        self.routineWeekCalendarRouting = router
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
    
    func attachRoutineDetail(routineId: UUID, recordDate: Date) {
        if routineDetailRouting != nil{
            return
        }
        
        let router = routineDetailBuildable.build(withListener: interactor, routineId: routineId, recordDate: recordDate)
        let navigation = NavigationControllerable(root: router.viewControllable)
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .white.withAlphaComponent(0.3)
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let scrollAppearacne = UINavigationBarAppearance()
        scrollAppearacne.configureWithTransparentBackground()
        scrollAppearacne.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let nav = navigation.navigationController
        nav.navigationBar.standardAppearance  = standardAppearance
        nav.navigationBar.scrollEdgeAppearance = scrollAppearacne
        nav.navigationBar.tintColor = .black
        
        nav.presentationController?.delegate = interactor.presentationDelegateProxy
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
