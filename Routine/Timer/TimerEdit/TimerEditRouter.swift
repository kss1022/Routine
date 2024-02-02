//
//  TimerEditRouter.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import ModernRIBs

protocol TimerEditInteractable: Interactable, EditFocusTimerListener , EditTabataTimerListener, EditRoundTimerListener {
    var router: TimerEditRouting? { get set }
    var listener: TimerEditListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol TimerEditViewControllable: ViewControllable {
}

final class TimerEditRouter: Router<TimerEditInteractable>, TimerEditRouting {

    private let editFocusTimerBuildable: EditFocusTimerBuildable
    private var editFocusTimerRouting: Routing?
    
    
    private let editTabataTimerBuildable: EditTabataTimerBuildable
    private var editTabataTimerRouting: Routing?
    
    private let editRoundTimerBuildable: EditRoundTimerBuildable
    private var editRoundTimerRouting : Routing?
    
    
    init(
        interactor: TimerEditInteractable,
        viewController: ViewControllable,
        editFocusTimerBuildable: EditFocusTimerBuildable,
        editTabataTimerBuildable: EditTabataTimerBuildable,
        editRoundTimerBuildable: EditRoundTimerBuildable
    ) {
        self.viewController = viewController
        self.editFocusTimerBuildable = editFocusTimerBuildable
        self.editTabataTimerBuildable = editTabataTimerBuildable
        self.editRoundTimerBuildable = editRoundTimerBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachEditFocusTimer(timerId: UUID) {
        if editFocusTimerRouting != nil{
            return
        }
        
        let router = editFocusTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        editFocusTimerRouting = router
        attachChild(router)
    }
    
    
    func detachEditFocusTimer() {
        guard let router = editFocusTimerRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        editFocusTimerRouting = nil
    }
    
    
    func attachEditTabataTimer(timerId: UUID) {
        if editTabataTimerRouting != nil{
            return
        }
        
        let router = editTabataTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        editTabataTimerRouting = router
        attachChild(router)
    }
    
    func detachEditTabataTimer() {
        guard let router = editTabataTimerRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        editTabataTimerRouting = nil
    }
    
    

    func attachEditRoundTimer(timerId: UUID) {
        if editRoundTimerRouting != nil{
            return
        }
        
        let router = editRoundTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        editRoundTimerRouting = router
        attachChild(router)
    }
    
    func detachEditRoundTimer() {
        guard let router = editRoundTimerRouting else { return }
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        editRoundTimerRouting = nil
    }


    // MARK: - Private
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.modalPresentationStyle = .fullScreen
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(completion: nil)
        self.navigationControllable = nil
    }
    
    private var navigationControllable: NavigationControllerable?
    private let viewController: ViewControllable
}
