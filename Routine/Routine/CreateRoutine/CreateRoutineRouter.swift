//
//  CreateRoutineRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import ModernRIBs
import UIKit


protocol CreateRoutineInteractable: Interactable , AddYourRoutineListener{
    var router: CreateRoutineRouting? { get set }
    var listener: CreateRoutineListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol CreateRoutineViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateRoutineRouter: ViewableRouter<CreateRoutineInteractable, CreateRoutineViewControllable>, CreateRoutineRouting {

    private let addYourRoutinBuildable: AddYourRoutineBuildable
    private var addYoutRoutineRouting: AddYourRoutineRouting?
    
    
    init(
        interactor: CreateRoutineInteractable,
        viewController: CreateRoutineViewControllable,
        addYourRoutineBuildable: AddYourRoutineBuildable
    ) {
        self.addYourRoutinBuildable = addYourRoutineBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachAddYourRoutine() {
        if addYoutRoutineRouting != nil{
            return
        }
        
        let router = addYourRoutinBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        

        
//        navigation.navigationController.navigationBar.isTranslucent = false
//        navigation.navigationController.navigationBar.backgroundColor = .clear

        
        let appear = UINavigationBarAppearance()
        appear.configureWithTransparentBackground()
        navigation.navigationController.navigationBar.standardAppearance  = appear
        navigation.navigationController.navigationBar.scrollEdgeAppearance = navigation.navigationController.navigationBar.standardAppearance

        
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        addYoutRoutineRouting = router
        attachChild(router)
        
    }
    
    func detachAddYoutRoutine() {
        guard let router = addYoutRoutineRouting else {
            return
        }
        
        detachChild(router)
        addYoutRoutineRouting = nil
    }
}
