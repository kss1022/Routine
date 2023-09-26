//
//  RoutineHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RoutineHomeInteractable: Interactable , CreateRoutineListener{
    var router: RoutineHomeRouting? { get set }
    var listener: RoutineHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol RoutineHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RoutineHomeRouter: ViewableRouter<RoutineHomeInteractable, RoutineHomeViewControllable>, RoutineHomeRouting {

    
    private let createRoutineBuildable: CreateRoutineBuildable
    private var createRoutineRouting: Routing?
    
    init(
        interactor: RoutineHomeInteractable,
        viewController: RoutineHomeViewControllable,
        createRoutineBuildable: CreateRoutineBuildable
    ) {
        self.createRoutineBuildable = createRoutineBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachCreateRoutine() {
        if createRoutineRouting != nil{
            return
        }
        
        let router = createRoutineBuildable.build(withListener: interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        
        navigation.navigationController.navigationBar.prefersLargeTitles = true
        navigation.navigationController.navigationItem.largeTitleDisplayMode = .always

        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        createRoutineRouting = router
        attachChild(router)
    }
    
    func detachCreateRoutine() {
        guard let router = createRoutineRouting else {
          return
        }
                
        detachChild(router)
        createRoutineRouting = nil
    }
    
    
}
