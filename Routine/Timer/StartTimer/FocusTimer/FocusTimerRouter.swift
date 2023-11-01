//
//  FocusTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusTimerInteractable: Interactable, FocusRoundTimerListener {
    var router: FocusTimerRouting? { get set }
    var listener: FocusTimerListener? { get set }
}

protocol FocusTimerViewControllable: ViewControllable {
    func addRoundTimer(_ view: ViewControllable)
}

final class FocusTimerRouter: ViewableRouter<FocusTimerInteractable, FocusTimerViewControllable>, FocusTimerRouting {
    
    

    private let focusRoundTimerBuildable: FocusRoundTimerBuildable
    private var focusRoundTimerRouting: Routing?
    
    
    init(
        interactor: FocusTimerInteractable,
        viewController: FocusTimerViewControllable,
        focusRoundTimerBuildable: FocusRoundTimerBuildable
    ) {
        self.focusRoundTimerBuildable = focusRoundTimerBuildable        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachFocusRoundTimer() {
        if focusRoundTimerRouting != nil{
            return
        }
        
        let routing = focusRoundTimerBuildable.build(withListener: interactor)
        viewController.addRoundTimer(routing.viewControllable)
        
        focusRoundTimerRouting = routing
        attachChild(routing)        
    }
}
