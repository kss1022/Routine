//
//  AddYourTimerRouter.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs

protocol AddYourTimerInteractable: Interactable, AddFocusTimerListener, AddTabataTimerListener, AddRoundTimerListener {
    var router: AddYourTimerRouting? { get set }
    var listener: AddYourTimerListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol AddYourTimerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class AddYourTimerRouter: Router<AddYourTimerInteractable>, AddYourTimerRouting {

    private let addFocusTimerBuildable: AddFocusTimerBuildable
    private var addFocusTimerRouting: Routing?
    
    private let addTabataTimerBuildable: AddTabataTimerBuildable
    private var addTabataTimerRouting: Routing?
    
    private let addRoundTimerBuildable: AddRoundTimerBuildable
    private var addRoundTimerRouting: Routing?
    
    init(
        interactor: AddYourTimerInteractable,
        viewController: ViewControllable,
        addFocusTimerBuildable: AddFocusTimerBuildable,
        addTabataTimerBuildable: AddTabataTimerBuildable,
        addRoundTimerBuildable: AddRoundTimerBuildable
    ) {
        self.addFocusTimerBuildable = addFocusTimerBuildable
        self.addTabataTimerBuildable = addTabataTimerBuildable
        self.addRoundTimerBuildable = addRoundTimerBuildable
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
          navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachAddFocusTimer() {
        if addFocusTimerRouting != nil{
            return
        }
        
        let router = addFocusTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addFocusTimerRouting = router
    }
    
    func detachAddFocusTimer(dismiss: Bool) {
        guard let router = addFocusTimerRouting else { return }

        
        if dismiss{
            dismissPresentedNavigation(completion: nil)
        }

        detachChild(router)
        self.navigationControllable = nil
        addFocusTimerRouting = nil
    }
    
    func attachAddTabataTimer() {
        if addTabataTimerRouting != nil{
            return
        }
        
        let router = addTabataTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addTabataTimerRouting = router
    }
    
    func detachAddTabataTimer(dismiss: Bool) {
        guard let router = addTabataTimerRouting else { return }

        
        if dismiss{
            dismissPresentedNavigation(completion: nil)
        }

        detachChild(router)
        self.navigationControllable = nil
        addTabataTimerRouting = nil
    }
    
    
    func attachAddRoundTimer() {
        if addRoundTimerRouting != nil{
            return
        }
        
        let router = addRoundTimerBuildable.build(withListener: interactor)
        
        if let navigationController = navigationControllable{
            navigationController.pushViewController(router.viewControllable, animated: true)
        }else{
            presentInsideNavigation(router.viewControllable)
        }
        
        attachChild(router)
        addRoundTimerRouting = router
    }
    
    func detachAddRoundTimer(dismiss: Bool) {
        guard let router = addRoundTimerRouting else { return }
                        
        if dismiss{
            dismissPresentedNavigation(completion: nil)
        }
        
        detachChild(router)
        self.navigationControllable = nil
        addRoundTimerRouting = nil
    }

    // MARK: - Private
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
      let navigation = NavigationControllerable(root: viewControllable)
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
