//
//  CreateTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol CreateTimerInteractable: Interactable, AddYourTimerListener {
    var router: CreateTimerRouting? { get set }
    var listener: CreateTimerListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }

}

protocol CreateTimerViewControllable: ViewControllable {
}

final class CreateTimerRouter: ViewableRouter<CreateTimerInteractable, CreateTimerViewControllable>, CreateTimerRouting {

    private let addYourTimerBuildable: AddYourTimerBuildable
    private var addYourTimerRouting: Routing?
    
    
    init(
        interactor: CreateTimerInteractable,
        viewController: CreateTimerViewControllable,
        addYourTimerBuildable: AddYourTimerBuildable
    ) {
        self.addYourTimerBuildable = addYourTimerBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAddYourTimer(timerType: AddTimerType) {
        if addYourTimerRouting != nil{
            return
        }
        
        let router = addYourTimerBuildable.build(withListener: interactor, timerType: timerType)        
        addYourTimerRouting = router
        attachChild(router)
    }
    
    func detachAddYourTimer() {
        guard let router = addYourTimerRouting else { return }
        detachChild(router)
        addYourTimerRouting = nil
    }
}
