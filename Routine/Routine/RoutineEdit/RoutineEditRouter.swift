//
//  RoutineEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import ModernRIBs

protocol RoutineEditInteractable: Interactable, RoutineEditTitleListener, RoutineEditStyleListener , RoutineEditRepeatListener, RoutineEditReminderListener{
    var router: RoutineEditRouting? { get set }
    var listener: RoutineEditListener? { get set }
}

protocol RoutineEditViewControllable: ViewControllable{
    func addTitle(_ view: ViewControllable)
    func addTint(_ view: ViewControllable)
    func addEmojiIcon(_ view: ViewControllable)
    func addRepeat(_ view: ViewControllable)
    func addReminder(_ view: ViewControllable)
}

final class RoutineEditRouter: ViewableRouter<RoutineEditInteractable, RoutineEditViewControllable>, RoutineEditRouting {

    private let routineEditTitleBuildable: RoutineEditTitleBuildable
    private var routineEditTitleRouting: Routing?
    
    private let routineEditStyleBuildable: RoutineEditStyleBuildable
    private var routineEditStyleRouting: Routing?
    
    
    private let routineEditRepeatBuidlable: RoutineEditRepeatBuildable
    private var routineEditRepeatRouting: Routing?
    
    private let routineEditReminderBuildable: RoutineEditReminderBuildable
    private var routineEditReminderRouting: Routing?
    
    init(
        interactor: RoutineEditInteractable,
        viewController: RoutineEditViewControllable,
        routineEditTitleBuildable: RoutineEditTitleBuildable,
        routineEditStyleBuildable: RoutineEditStyleBuildable,
        routineEditRepeatBuidlable: RoutineEditRepeatBuildable,
        routineEditReminderBuildable: RoutineEditReminderBuildable
    ) {
        self.routineEditTitleBuildable = routineEditTitleBuildable
        self.routineEditStyleBuildable = routineEditStyleBuildable
        self.routineEditRepeatBuidlable = routineEditRepeatBuidlable
        self.routineEditReminderBuildable = routineEditReminderBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachRoutineTitle() {
        if routineEditTitleRouting != nil{
            return
        }
        
        let router = routineEditTitleBuildable.build(withListener: interactor)
        viewController.addTitle(router.viewControllable)
        
        routineEditTitleRouting = router
        attachChild(router)
    }    

    func attachRoutineRepeat() {
        if routineEditRepeatRouting != nil{
            return
        }
        
        let router = routineEditRepeatBuidlable.build(withListener: interactor)
        viewController.addRepeat(router.viewControllable)
        
        self.routineEditRepeatRouting = router
        attachChild(router)
    }
    
    func attachRoutineReminder() {
        if routineEditReminderRouting != nil{
            return
        }
        
        let router = routineEditReminderBuildable.build(withListener: interactor)
        viewController.addReminder(router.viewControllable)
        
        self.routineEditReminderRouting = router
        attachChild(router)
    }
    
    func attachRoutineStyle() {
        if routineEditStyleRouting != nil{
            return
        }
        
        let router = routineEditStyleBuildable.build(withListener: interactor)
        viewController.addTint(router.viewControllable)
        
        
        self.routineEditStyleRouting = router
        attachChild(router)
    }
    
}
