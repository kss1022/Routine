//
//  AddYourRoutineRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol AddYourRoutineInteractable: Interactable ,RoutineEditTitleListener, RoutineEditStyleListener , RoutineEditRepeatListener, RoutineEditReminderListener{
    var router: AddYourRoutineRouting? { get set }
    var listener: AddYourRoutineListener? { get set }
}

protocol AddYourRoutineViewControllable: ViewControllable {
    func addTitle(_ view : ViewControllable)
    func addTint(_ view: ViewControllable)
    func addEmojiIcon(_ view: ViewControllable)
    func addRepeat(_ view: ViewControllable)
    func addReminder(_ view: ViewControllable)
}

final class AddYourRoutineRouter: ViewableRouter<AddYourRoutineInteractable, AddYourRoutineViewControllable>, AddYourRoutineRouting {

    private let routineEditTitleBuildable: RoutineEditTitleBuildable
    private var routineEditTitleRouting: Routing?
    
    private let routineEditStyleBuildable: RoutineEditStyleBuildable
    private var routineEditStyleRouting: Routing?
    
    
    private let routineEditRepeatBuidlable: RoutineEditRepeatBuildable
    private var routineEditRepeatRouting: Routing?
    
    private let routineEditReminderBuildable: RoutineEditReminderBuildable
    private var routineEditReminderRouting: Routing?
    
    
    init(
        interactor: AddYourRoutineInteractable,
        viewController: AddYourRoutineViewControllable,
        routineEditTitleBuildable: RoutineEditTitleBuildable,
        routineEditStyleBuildable: RoutineEditStyleBuildable,
        routineEditRepeatBuildable: RoutineEditRepeatBuildable,
        routineEditReminderBuildable: RoutineEditReminderBuildable
    ) {
        self.routineEditTitleBuildable = routineEditTitleBuildable
        self.routineEditStyleBuildable = routineEditStyleBuildable
        self.routineEditRepeatBuidlable = routineEditRepeatBuildable
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
        
        self.routineEditTitleRouting = router
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
        viewController.addRepeat(router.viewControllable)
        
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
