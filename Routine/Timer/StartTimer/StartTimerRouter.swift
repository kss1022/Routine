//
//  StartTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs

protocol StartTimerInteractable: Interactable, FocusTimerListener, TabataTimerListener, RoundTimerListener {
    var router: StartTimerRouting? { get set }
    var listener: StartTimerListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol StartTimerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class StartTimerRouter: Router<StartTimerInteractable>, StartTimerRouting {
    
    
    private let focusTimerBuildable: FocusTimerBuildable
    private var focusTimerRouting: Routing?
    
    private let tabataTimerBuildable: TabataTimerBuildable
    private var tabataTimerRouting: Routing?

    private let roundTimerBuildable: RoundTimerBuildable
    private var roundTimerRouting: Routing?
    
    init(
        interactor: StartTimerInteractable,
        viewController: ViewControllable,
        focusTimerBuildable: FocusTimerBuildable,
        tabataTimerBuildable: TabataTimerBuildable,
        roundTimerBuildable: RoundTimerBuildable
    ) {
        self.viewController = viewController
        self.focusTimerBuildable = focusTimerBuildable
        self.tabataTimerBuildable = tabataTimerBuildable
        self.roundTimerBuildable = roundTimerBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    
    func attachFocusTimer() {
        if focusTimerRouting != nil{
            return
        }
        
        let router = focusTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        focusTimerRouting = router
        attachChild(router)
    }
    
    func detachFocusTimer() {
        guard let router = focusTimerRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        focusTimerRouting = nil
    }
    
    
    func attachTabataTimer() {
        if tabataTimerRouting != nil{
            return
        }
        
        let router = tabataTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }

        tabataTimerRouting = router
        attachChild(router)
    }
    
    func detachTabataTimer() {
        guard let router = tabataTimerRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        tabataTimerRouting = nil
    }
    
    
    func attachRoundTimer() {
        if roundTimerRouting != nil{
            return
        }
        
        let router = roundTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }

        roundTimerRouting = router
        attachChild(router)
    }
    
    func detachRoundTimer() {
        guard let router = roundTimerRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        roundTimerRouting = nil
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
