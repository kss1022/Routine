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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileEditNameRouter: ViewableRouter<ProfileEditNameInteractable, ProfileEditNameViewControllable>, ProfileEditNameRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileEditNameInteractable, viewController: ProfileEditNameViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
