//
//  ProfileEditRouter.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import ModernRIBs

protocol ProfileEditInteractable: Interactable, ProfileEditNameListener, ProfileEditDescriptionListener, ProfileEditMemojiListener {
    var router: ProfileEditRouting? { get set }
    var listener: ProfileEditListener? { get set }
}

protocol ProfileEditViewControllable: ViewControllable {
    func setTitle(_ view: ViewControllable)
}

final class ProfileEditRouter: ViewableRouter<ProfileEditInteractable, ProfileEditViewControllable>, ProfileEditRouting {
    
    private let profileEditNameBuildable: ProfileEditNameBuildable
    private var profileEditNameRouting: Routing?
    
    private let profileEditDescriptionBuildable: ProfileEditDescriptionBuildable
    private var profileEditDescriptionRouting: Routing?

    private let profilEditMemojiBuildable: ProfileEditMemojiBuildable
    private var profileEditMemojiRouting: Routing?
    
    init(
        interactor: ProfileEditInteractable,
        viewController: ProfileEditViewControllable,
        profileEditNameBuildable: ProfileEditNameBuildable,
        profileEditDescriptionBuildable: ProfileEditDescriptionBuildable,
        profilEditMemojiBuildable: ProfileEditMemojiBuildable
    ) {
        self.profileEditNameBuildable = profileEditNameBuildable
        self.profileEditDescriptionBuildable = profileEditDescriptionBuildable
        self.profilEditMemojiBuildable = profilEditMemojiBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachProfileEditName() {
        if profileEditNameRouting != nil{
            return
        }
        
        let router = profileEditNameBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        profileEditNameRouting = router
        attachChild(router)
    }
    
    func detachProfileEditName() {
        guard let router = profileEditNameRouting else { return }
        detachChild(router)
        profileEditNameRouting = nil
    }
    
    func popProfileEditName() {
        guard let router = profileEditNameRouting else { return }
        detachChild(router)
        viewController.popViewController(animated: true)
        profileEditNameRouting = nil
    }
    
    func attachProfileEditDescription() {
        if profileEditDescriptionRouting != nil{
            return
        }
        
        let router = profileEditDescriptionBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        profileEditDescriptionRouting = router
        attachChild(router)
    }
    
    func detachProfileEditDescription() {
        guard let router = profileEditDescriptionRouting else { return }
        detachChild(router)
        profileEditDescriptionRouting = nil
    }
    
    func popProfileEditDescription() {
        guard let router = profileEditDescriptionRouting else { return }
        viewController.popViewController(animated: true)
        detachChild(router)
        profileEditDescriptionRouting = nil        
    }
    
    func attchProfileEditMemoji() {
        if profileEditMemojiRouting != nil{
            return
        }
        
        let router = profilEditMemojiBuildable.build(withListener: interactor)
        viewController.setTitle(router.viewControllable)
        
        profileEditMemojiRouting = router
        attachChild(router)
    }
}
