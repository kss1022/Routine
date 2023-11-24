//
//  ProfileAcheiveRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileAcheiveInteractable: Interactable {
    var router: ProfileAcheiveRouting? { get set }
    var listener: ProfileAcheiveListener? { get set }
}

protocol ProfileAcheiveViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileAcheiveRouter: ViewableRouter<ProfileAcheiveInteractable, ProfileAcheiveViewControllable>, ProfileAcheiveRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileAcheiveInteractable, viewController: ProfileAcheiveViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
