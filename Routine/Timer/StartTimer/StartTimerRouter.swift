//
//  StartTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs

protocol StartTimerInteractable: Interactable, FocusTimerListener, SectionTimerListener {
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
    
    private let sectionTimerBuildable: SectionTimerBuildable
    private var sectionTimerRouting: Routing?
    
    
    init(
        interactor: StartTimerInteractable,
        viewController: ViewControllable,
        focusTimerBuildable: FocusTimerBuildable,
        sectionTimerBuildable: SectionTimerBuildable
    ) {
        self.viewController = viewController
        self.focusTimerBuildable = focusTimerBuildable
        self.sectionTimerBuildable = sectionTimerBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    
    func attachFocusTimer(model: TimerFocusModel) {
        if focusTimerRouting != nil{
            return
        }
        
        let router = focusTimerBuildable.build(withListener: interactor, model: model)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        focusTimerRouting = router
    }
    
    func detachFocusTimer() {
        guard let router = focusTimerRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        focusTimerRouting = nil
    }
    
    
    func attachSectionTimer(model: TimerSectionsModel) {
        if sectionTimerRouting != nil{
            return
        }
        
        let router = sectionTimerBuildable.build(withListener: interactor, model: model)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        sectionTimerRouting = router
    }
    
    func detachSectionTimer() {
        guard let router = sectionTimerRouting else { return }
        
        dismissPresentedNavigation(completion: nil)
        detachChild(router)
        sectionTimerRouting = nil
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
