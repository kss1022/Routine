//
//  AppRootRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, AppHomeListener, AppTutorialListener{
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable{
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    
    private let appHomeBuildable: AppHomeBuildable
    private var appHomeRouting: Routing?
    
    private let appTutorailBuildable: AppTutorialBuildable
    private var appTutorialRouting: Routing?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        appHomeBuildable: AppHomeBuildable,
        appTutorailBuildable: AppTutorialBuildable
    ) {
        self.appHomeBuildable = appHomeBuildable
        self.appTutorailBuildable = appTutorailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachAppHome() {
        if let appTutorialRouting = self.appTutorialRouting {
            detachChild(appTutorialRouting)
            viewController.dismiss(animated: false, completion: nil)
            self.appTutorialRouting = nil
        }
                

        let router = appHomeBuildable.build(withListener: interactor)
        appHomeRouting = router
        attachChild(router)
    }
    
    
    func attachAppTutorial() {
        if appTutorialRouting != nil{
            return
        }
        
        let router = appTutorailBuildable.build(withListener: interactor)
        appTutorialRouting = router
        attachChild(router)
    }
    
}
