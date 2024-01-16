//
//  EditRoundTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs

protocol EditRoundTimerInteractable: Interactable, TimerSectionEditListener, TimerEditTitleListener, TimerSectionListListener {
    var router: EditRoundTimerRouting? { get set }
    var listener: EditRoundTimerListener? { get set }
}

protocol EditRoundTimerViewControllable: ViewControllable {
    func addEditTitle(_ view: ViewControllable)
    func addSectionLists(_ view: ViewControllable)
}

final class EditRoundTimerRouter: ViewableRouter<EditRoundTimerInteractable, EditRoundTimerViewControllable>, EditRoundTimerRouting {

    
    private let timerEditTitleBuildable: TimerEditTitleBuildable
    private var timerEditTitleRouting: TimerEditTitleRouting?
    
    private let timerSectionListBuildable: TimerSectionListBuildable
    private var timerSectionListRouting: TimerSectionListRouting?
    
    private let timerSectionEditBuildable: TimerSectionEditBuildable
    private var timerSectionEditRouting: TimerSectionEditRouting?
    
    init(
        interactor: EditRoundTimerInteractable,
        viewController: EditRoundTimerViewControllable,
        timerEditTitleBuildable: TimerEditTitleBuildable,
        timerSectionListBuildable: TimerSectionListBuildable,
        timerSectionEditBuildable: TimerSectionEditBuildable
    ) {
        self.timerEditTitleBuildable = timerEditTitleBuildable
        self.timerSectionListBuildable = timerSectionListBuildable
        self.timerSectionEditBuildable = timerSectionEditBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachTimerSectionEdit(sectionList: TimerSectionListModel) {
        if timerSectionEditRouting != nil{
            return
        }
        
        let router = timerSectionEditBuildable.build(withListener: interactor, sectionList: sectionList)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        timerSectionEditRouting = router
        attachChild(router)
    }
    
    func detachTimerSectionEdit() {
        guard let router = timerSectionEditRouting else { return }
        
        detachChild(router)
        timerSectionEditRouting = nil
    }
    
    func attachTimerEditTitle(name: String, emoji: String) {
        if timerEditTitleRouting != nil{
            return
        }
        
        
        let router = timerEditTitleBuildable.build(withListener: interactor, name: name, emoji: emoji)
        viewController.addEditTitle(router.viewControllable)
        
        timerEditTitleRouting = router
        attachChild(router)
    }
   
    func attachTimerSectionList() {
        if timerSectionListRouting != nil{
            return
        }
        
        let router = timerSectionListBuildable.build(withListener: interactor)
        viewController.addSectionLists(router.viewControllable)
        
        timerSectionListRouting = router
        attachChild(router)
    }

}
