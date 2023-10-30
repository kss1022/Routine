//
//  RoutineDetailRouter.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import UIKit

protocol RoutineDetailInteractable: Interactable , RoutineEditListener, RoutineTitleListener, RecordCalendarListener, RoutineBasicInfoListener{
    var router: RoutineDetailRouting? { get set }
    var listener: RoutineDetailListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol RoutineDetailViewControllable: ViewControllable {
    func addTitle(_ view: ViewControllable)
    func addRecordCalendar(_ view: ViewControllable)
    func addBasicInfo(_ view: ViewControllable)
}

final class RoutineDetailRouter: ViewableRouter<RoutineDetailInteractable, RoutineDetailViewControllable>, RoutineDetailRouting {


    private let routineEditBuildable: RoutineEditBuildable
    private var routineEditRouting: Routing?
    
    private let routineTitleBuildable: RoutineTitleBuildable
    private var routineTitleRouting: Routing?
    
    private let recordCalendarBuildable: RecordCalendarBuildable
    private var recordCalendarRouting: Routing?
    
    private let routineBasicInfoBuildable: RoutineBasicInfoBuildable
    private var routineBasicInfoRouting: Routing?

    
    init(
        interactor: RoutineDetailInteractable,
        viewController: RoutineDetailViewControllable,
        routineEditBuildable: RoutineEditBuildable,
        routineTitleBuildable: RoutineTitleBuildable,
        recordCalendarBuildable: RecordCalendarBuildable,
        routineBasicInfoBuildable: RoutineBasicInfoBuildable
    ) {
        self.routineEditBuildable = routineEditBuildable
        self.routineTitleBuildable = routineTitleBuildable
        self.recordCalendarBuildable = recordCalendarBuildable
        self.routineBasicInfoBuildable = routineBasicInfoBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
        
    func attachRoutineEdit(routineId: UUID) {
        if routineEditRouting != nil{
            return
        }
    
        
        let router = routineEditBuildable.build(withListener: interactor, routineId: routineId)
        let navigation = NavigationControllerable(root: router.viewControllable)
        
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
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
        
        routineEditRouting = router
        attachChild(router)
    }
    
    func detachRoutineEdit(dismiss: Bool) {
        guard let router = routineEditRouting else {
            return
        }
        
        if dismiss{                        
            viewController.dismiss(completion: nil)
        }            
                
        detachChild(router)
        routineEditRouting = nil
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
    
    func attachRecordCalendar() {
        if recordCalendarRouting != nil{
            return
        }
        
        let routing = recordCalendarBuildable.build(withListener: interactor)
        viewController.addRecordCalendar(routing.viewControllable)
        
        self.recordCalendarRouting = routing
        attachChild(routing)
    }

    
    func attachRoutineBasicInfo() {
        if routineBasicInfoRouting != nil{
            return
        }
        
        let routing = routineBasicInfoBuildable.build(withListener: interactor)
        viewController.addBasicInfo(routing.viewControllable)
        
        self.routineBasicInfoRouting = routing
        attachChild(routing)
    }
}
