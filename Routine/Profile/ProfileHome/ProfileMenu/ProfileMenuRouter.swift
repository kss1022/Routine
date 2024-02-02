//
//  ProfileMenuRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileMenuInteractable: Interactable {
    var router: ProfileMenuRouting? { get set }
    var listener: ProfileMenuListener? { get set }
}

protocol ProfileMenuViewControllable: ViewControllable {
}

final class ProfileMenuRouter: ViewableRouter<ProfileMenuInteractable, ProfileMenuViewControllable>, ProfileMenuRouting {

    override init(interactor: ProfileMenuInteractable, viewController: ProfileMenuViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
