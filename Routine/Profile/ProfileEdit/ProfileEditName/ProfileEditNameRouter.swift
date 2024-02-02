//
//  ProfileEditNameRouter.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditNameInteractable: Interactable {
    var router: ProfileEditNameRouting? { get set }
    var listener: ProfileEditNameListener? { get set }
}

protocol ProfileEditNameViewControllable: ViewControllable {
}

final class ProfileEditNameRouter: ViewableRouter<ProfileEditNameInteractable, ProfileEditNameViewControllable>, ProfileEditNameRouting {

    override init(interactor: ProfileEditNameInteractable, viewController: ProfileEditNameViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
