//
//  AddYourTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol AddYourTimerInteractable: Interactable, TimerSectionEditListener, TimerSectionListListener {
    var router: AddYourTimerRouting? { get set }
    var listener: AddYourTimerListener? { get set }
}

protocol AddYourTimerViewControllable: ViewControllable {
    func addEditSection(_ view: ViewControllable)
}

final class AddYourTimerRouter: ViewableRouter<AddYourTimerInteractable, AddYourTimerViewControllable>, AddYourTimerRouting {

    private let timerSectionListBuildable: TimerSectionListBuildable
    private var timerSectionListRouting: TimerSectionListRouting?
    
    private let timerSectionEditBuildable: TimerSectionEditBuildable
    private var timerSectionEditRouting: TimerSectionEditRouting?
    
    init(
        interactor: AddYourTimerInteractable,
        viewController: AddYourTimerViewControllable,
        timerSectionEditBuildable: TimerSectionEditBuildable,
        timerSectionListBuildable: TimerSectionListBuildable
    ) {
        self.timerSectionEditBuildable = timerSectionEditBuildable
        self.timerSectionListBuildable = timerSectionListBuildable        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachTimerSectionEdit() {
        if timerSectionEditRouting != nil{
            return
        }
        
        let router = timerSectionEditBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        timerSectionEditRouting = router
        attachChild(router)
    }
    
    func detachTimerSectionEdit() {
        guard let router = timerSectionEditRouting else { return }
        
        detachChild(router)
        timerSectionEditRouting = nil
    }
    
    func attachTimerSectionListection() {
        if timerSectionListRouting != nil{
            return
        }
        
        let router = timerSectionListBuildable.build(withListener: interactor)
        viewController.addEditSection(router.viewControllable)
        
        timerSectionListRouting = router
        attachChild(router)
    }

}
