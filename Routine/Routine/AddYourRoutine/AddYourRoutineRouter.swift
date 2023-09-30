//
//  AddYourRoutineRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol AddYourRoutineInteractable: Interactable ,RoutineEditTitleListener, RoutineTintListener , RoutineEmojiIconListener{
    var router: AddYourRoutineRouting? { get set }
    var listener: AddYourRoutineListener? { get set }
}

protocol AddYourRoutineViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addTitle(_ view : ViewControllable)
    func addTint(_ view: ViewControllable)
    func addEmojiIcon(_ view: ViewControllable)
}

final class AddYourRoutineRouter: ViewableRouter<AddYourRoutineInteractable, AddYourRoutineViewControllable>, AddYourRoutineRouting {

    private let routineEditTitleBuildable: RoutineEditTitleBuildable
    private var routineEditTitleRouting: Routing?
    
    private let routineTintBuildable: RoutineTintBuildable
    private var routineTintRouting: Routing?
    
    private let routineEmojiIconBuildable: RoutineEmojiIconBuildable
    private var routineEmojiIconRouting : Routing?
    
    
    init(
        interactor: AddYourRoutineInteractable,
        viewController: AddYourRoutineViewControllable,
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
        
        self.routineEditTitleRouting = router
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
