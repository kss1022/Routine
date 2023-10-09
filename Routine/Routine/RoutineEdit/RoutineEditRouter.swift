//
//  RoutineEditRouter.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import ModernRIBs

protocol RoutineEditInteractable: Interactable, RoutineEditTitleListener, RoutineTintListener , RoutineEmojiIconListener{
    var router: RoutineEditRouting? { get set }
    var listener: RoutineEditListener? { get set }
}

protocol RoutineEditViewControllable: ViewControllable{
    func addTitle(_ view: ViewControllable)
    func addTint(_ view: ViewControllable)
    func addEmojiIcon(_ view: ViewControllable)
}

final class RoutineEditRouter: ViewableRouter<RoutineEditInteractable, RoutineEditViewControllable>, RoutineEditRouting {

    private let routineEditTitleBuildable: RoutineEditTitleBuildable
    private var routineEditTitleRouting: Routing?
    
    private let routineTintBuildable: RoutineTintBuildable
    private var routineTintRouting: Routing?
    
    private let routineEmojiIconBuildable: RoutineEmojiIconBuildable
    private var routineEmojiIconRouting : Routing?
    
    
    
    init(
        interactor: RoutineEditInteractable,
        viewController: RoutineEditViewControllable,
        routineEditTitleBuildable: RoutineEditTitleBuildable,
        routineTintBuildable: RoutineTintBuildable,
        routineEmojiIconBuildable: RoutineEmojiIconBuildable
    ) {
        self.routineEditTitleBuildable = routineEditTitleBuildable
        self.routineTintBuildable = routineTintBuildable
        self.routineEmojiIconBuildable = routineEmojiIconBuildable
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
}
