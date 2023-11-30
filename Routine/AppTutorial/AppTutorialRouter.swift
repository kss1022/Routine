//
//  AppTutorialRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialInteractable: Interactable, AppTutorialHomeListener, AppTutorialRoutineListener, AppTutorialProfileListener, AppTutorialTimerListener {
    var router: AppTutorialRouting? { get set }
    var listener: AppTutorialListener? { get set }
}

protocol AppTutorialViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class AppTutorialRouter: Router<AppTutorialInteractable>, AppTutorialRouting {

    private let appTutorailHomeBuildable: AppTutorialHomeBuildable
    private let appTutorialRoutineBuildable: AppTutorialRoutineBuildable
    private let appTutorialProfileBuildable: AppTutorialProfileBuildable
    private let appTutorialTimerBuildable: AppTutorialTimerBuildable
    
    
    private var tutorialRouting: Routing?
    
    
    init(
        interactor: AppTutorialInteractable,
        viewController: ViewControllable,
        appTutorailHomeBuildable: AppTutorialHomeBuildable,
        appTutorialRoutineBuildable: AppTutorialRoutineBuildable,
        appTutorialProfileBuildable: AppTutorialProfileBuildable,
        appTutorialTimerBuildable: AppTutorialTimerBuildable
    ) {
        self.appTutorailHomeBuildable = appTutorailHomeBuildable
        self.appTutorialRoutineBuildable = appTutorialRoutineBuildable
        self.appTutorialProfileBuildable =  appTutorialProfileBuildable
        self.appTutorialTimerBuildable = appTutorialTimerBuildable
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
            navigationControllable?.dismiss(completion: nil)
        }
    }
    
    func attachAppTutorialHome() {
        if tutorialRouting != nil{
            return
        }
        
        let router = appTutorailHomeBuildable.build(withListener: interactor)
        
        replaceModal(viewController: router.viewControllable)
        
        attachChild(router)
        tutorialRouting = router
    }
    
    func attachAppTutorialRoutine() {
        let router = appTutorialRoutineBuildable.build(withListener: interactor)
        replaceModal(viewController: router.viewControllable)
        attachChild(router)
        tutorialRouting = router
    }
    
    func attachAppTutorialProfile() {
        let router = appTutorialProfileBuildable.build(withListener: interactor)
        replaceModal(viewController: router.viewControllable)
        attachChild(router)
        tutorialRouting = router
    }
    
    func attachAppTutorailTimer() {
        let router = appTutorialTimerBuildable.build(withListener: interactor)
        replaceModal(viewController: router.viewControllable)
        attachChild(router)
        tutorialRouting = router
    }
    


    // MARK: - Private
    private func replaceModal(viewController: ViewControllable) {
        if self.navigationControllable != nil{
            if let router = tutorialRouting{
                detachChild(router)
                tutorialRouting = nil
            }
            
            dismissPresentedNavigation { [weak self] in
                self?.presentInsideNavigation(viewController)
            }
        }else{
            presentInsideNavigation(viewController)
        }

     }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        //navigation.navigationController.modalTransitionStyle = .crossDissolve
        navigation.navigationController.modalPresentationStyle = .fullScreen
        self.navigationControllable = navigation
        viewController.present(navigation, animated: false, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(animated: false, completion: completion)
        self.navigationControllable = nil
    }

    private var navigationControllable: NavigationControllerable?
    private let viewController: ViewControllable
}
