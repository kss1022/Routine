//
//  AppTutorialProfileRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialProfileInteractable: Interactable, AppTutorialMemojiListener {
    var router: AppTutorialProfileRouting? { get set }
    var listener: AppTutorialProfileListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol AppTutorialProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppTutorialProfileRouter: ViewableRouter<AppTutorialProfileInteractable, AppTutorialProfileViewControllable>, AppTutorialProfileRouting {

    private let appTutorialSetMemojiBuildable: AppTutorialMemojiBuildable
    private var appTutorialSetMemojiRouting: AppTutorialMemojiRouting?
    
    init(
        interactor: AppTutorialProfileInteractable,
        viewController: AppTutorialProfileViewControllable,
        appTutorialSetMemojiBuildable: AppTutorialMemojiBuildable
    ) {
        self.appTutorialSetMemojiBuildable = appTutorialSetMemojiBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAppTutorialSetMemoji() {
        if appTutorialSetMemojiRouting != nil{
            return
        }
        
        let router = appTutorialSetMemojiBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        
        viewController.present(navigation, animated: true, completion: nil)
        appTutorialSetMemojiRouting = router
        attachChild(router)
    }
    
    func detachAppTutorialSetMemoji() {
        guard let router = appTutorialSetMemojiRouting else { return }
        detachChild(router)
        appTutorialSetMemojiRouting = nil
    }
    
    func popAppTutorialSetMemoji() {
        guard let router = appTutorialSetMemojiRouting else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        appTutorialSetMemojiRouting = nil
    }
}
