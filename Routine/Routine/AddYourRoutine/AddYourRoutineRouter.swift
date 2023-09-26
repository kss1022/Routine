//
//  AddYourRoutineRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol AddYourRoutineInteractable: Interactable ,RoutineTitleListener, RoutineTintListener , RoutineImojiIconListener{
    var router: AddYourRoutineRouting? { get set }
    var listener: AddYourRoutineListener? { get set }
}

protocol AddYourRoutineViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addTitle(_ view : ViewControllable)
    func addTint(_ view: ViewControllable)
    func addImojiIcon(_ view: ViewControllable)
}

final class AddYourRoutineRouter: ViewableRouter<AddYourRoutineInteractable, AddYourRoutineViewControllable>, AddYourRoutineRouting {

    private let routineTitleBuildable: RoutineTitleBuildable
    private var routineTitleRouting: Routing?
    
    private let routineTintBuildable: RoutineTintBuildable
    private var routineTintRouting: Routing?
    
    private let routineImojiIconBuildable: RoutineImojiIconBuildable
    private var routineImojiIconRouting : Routing?
    
    
    init(
        interactor: AddYourRoutineInteractable,
        viewController: AddYourRoutineViewControllable,
        routineTitleBuildable: RoutineTitleBuildable,
        routineTintBuildable: RoutineTintBuildable,
        routineImojiIconBuildable: RoutineImojiIconBuildable
    ) {
        self.routineTitleBuildable = routineTitleBuildable
        self.routineTintBuildable = routineTintBuildable
        self.routineImojiIconBuildable = routineImojiIconBuildable
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
    
    func attachRoutineTint() {
        if routineTintRouting != nil{
            return
        }
        
        let router = routineTintBuildable.build(withListener: interactor)
        viewController.addTint(router.viewControllable)
        
        self.routineTintRouting = router
        attachChild(router)
    }
    
    func attachRoutineImojiIcon() {
        if routineImojiIconRouting != nil{
            return
        }
        
        let router = routineImojiIconBuildable.build(withListener: interactor)
        viewController.addImojiIcon(router.viewControllable)
        
        self.routineImojiIconRouting = router
        attachChild(router)
    }
}
