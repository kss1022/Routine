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
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let scrollAppearacne = UINavigationBarAppearance()
        scrollAppearacne.configureWithTransparentBackground()
        scrollAppearacne.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let nav = navigation.navigationController
        nav.navigationBar.standardAppearance  = standardAppearance
        nav.navigationBar.scrollEdgeAppearance = scrollAppearacne
        nav.navigationBar.tintColor = .black

                
        nav.presentationController?.delegate = interactor.presentationDelegateProxy                        
        viewController.present(navigation, animated: true, completion: nil)
        
        addYoutRoutineRouting = router
        attachChild(router)
        
    }
    
    func detachAddYoutRoutine(dismiss: Bool) {
        guard let router = addYoutRoutineRouting else {
            return
        }
        
        if dismiss{
            viewController.dismiss(completion: nil)
        }
        
        detachChild(router)
        addYoutRoutineRouting = nil
    }

}
