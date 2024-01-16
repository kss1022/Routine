//
//  AddTabataTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddTabataTimerInteractable: Interactable, TimerSectionEditListener, TimerEditTitleListener, TimerSectionListListener {
    var router: AddTabataTimerRouting? { get set }
    var listener: AddTabataTimerListener? { get set }
}

protocol AddTabataTimerViewControllable: ViewControllable {
    func addEditTitle(_ view: ViewControllable)
    func addSectionLists(_ view: ViewControllable)
}

final class AddTabataTimerRouter: ViewableRouter<AddTabataTimerInteractable, AddTabataTimerViewControllable>, AddTabataTimerRouting {
    
    
    
    private let timerEditTitleBuildable: TimerEditTitleBuildable
    private var timerEditTitleRouting: TimerEditTitleRouting?
    
    private let timerSectionListBuildable: TimerSectionListBuildable
    private var timerSectionListRouting: TimerSectionListRouting?
    
    private let timerSectionEditBuildable: TimerSectionEditBuildable
    private var timerSectionEditRouting: TimerSectionEditRouting?
    
    init(
        interactor: AddTabataTimerInteractable,
        viewController: AddTabataTimerViewControllable,
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
