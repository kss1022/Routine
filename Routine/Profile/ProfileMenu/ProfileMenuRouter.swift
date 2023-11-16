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
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileMenuRouter: ViewableRouter<ProfileMenuInteractable, ProfileMenuViewControllable>, ProfileMenuRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileMenuInteractable, viewController: ProfileMenuViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
