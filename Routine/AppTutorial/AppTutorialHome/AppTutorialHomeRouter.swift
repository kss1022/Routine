//
//  AppTutorialHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import ModernRIBs

protocol AppTutorialHomeInteractable: Interactable, AppTutorialMainListener, AppTutorialSplashListener {
    var router: AppTutorialHomeRouting? { get set }
    var listener: AppTutorialHomeListener? { get set }
}

protocol AppTutorialHomeViewControllable: ViewControllable {
    func replaceView(_ view: ViewControllable)
}

final class AppTutorialHomeRouter: ViewableRouter<AppTutorialHomeInteractable, AppTutorialHomeViewControllable>, AppTutorialHomeRouting {

    
    private let appTutorailMainBuildable: AppTutorialMainBuildable
    private var attachedRouting: Routing?
    
    private let appTutorailSplashBuildable: AppTutorialSplashBuildable
    
    init(
        interactor: AppTutorialHomeInteractable,
        viewController: AppTutorialHomeViewControllable,
        appTutorailMainBuildable: AppTutorialMainBuildable,
        appTutorailSplashBuildable: AppTutorialSplashBuildable
    ) {
        self.appTutorailMainBuildable = appTutorailMainBuildable
        self.appTutorailSplashBuildable = appTutorailSplashBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAppTutorialMain() {
        if attachedRouting != nil{
            return
        }
        
        let router = appTutorailMainBuildable.build(withListener: interactor)
        replaceView(router.viewControllable)
        attachedRouting = router
        attachChild(router)
    }
    
    func attachAppTutorialSplash() {
        let router = appTutorailSplashBuildable.build(withListener: interactor)
        replaceView(router.viewControllable)
        attachedRouting = router
        attachChild(router)
    }
    
    
    //MARK: - Private
    private func replaceView(_ viewControllable: ViewControllable){
        if let attachedRouting = attachedRouting{
            detachChild(attachedRouting)
        }
        
        viewController.replaceView(viewControllable)
    }
    
    
}
