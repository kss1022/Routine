//
//  RoutineEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import ModernRIBs

protocol RoutineEditInteractable: Interactable, RoutineEditTitleListener, RoutineTintListener , RoutineEmojiIconListener, RoutineEditRepeatListener, RoutineEditReminderListener{
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
    
    private let routineTintBuildable: RoutineTintBuildable
    private var routineTintRouting: Routing?
    
    private let routineEmojiIconBuildable: RoutineEmojiIconBuildable
    private var routineEmojiIconRouting : Routing?
    
    private let routineEditRepeatBuidlable: RoutineEditRepeatBuildable
    private var routineEditRepeatRouting: Routing?
    
    private let routineEditReminderBuildable: RoutineEditReminderBuildable
    private var routineEditReminderRouting: Routing?
    
    init(
        interactor: RoutineEditInteractable,
        viewController: RoutineEditViewControllable,
        routineEditTitleBuildable: RoutineEditTitleBuildable,
        routineTintBuildable: RoutineTintBuildable,
        routineEmojiIconBuildable: RoutineEmojiIconBuildable,
        routineEditRepeatBuidlable: RoutineEditRepeatBuildable,
        routineEditReminderBuildable: RoutineEditReminderBuildable
    ) {
        self.routineEditTitleBuildable = routineEditTitleBuildable
        self.routineTintBuildable = routineTintBuildable
        self.routineEmojiIconBuildable = routineEmojiIconBuildable
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
    
    func attachRoutineTint() {
        if routineTintRouting != nil{
            return
        }
        
        let router = routineTintBuildable.build(withListener: interactor)
        viewController.addTint(router.viewControllable)
        
        
        self.routineTintRouting = router
        attachChild(router)
    }
    
    func attachRoutineEmojiIcon() {
        if routineEmojiIconRouting != nil{
            return
        }
        
        let router = routineEmojiIconBuildable.build(withListener: interactor)
        viewController.addEmojiIcon(router.viewControllable)
        
        self.routineEmojiIconRouting = router
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
}
