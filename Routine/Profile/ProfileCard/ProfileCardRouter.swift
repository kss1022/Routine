//
//  ProfileCardRouter.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import ModernRIBs

protocol ProfileCardInteractable: Interactable {
    var router: ProfileCardRouting? { get set }
    var listener: ProfileCardListener? { get set }
}

protocol ProfileCardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileCardRouter: ViewableRouter<ProfileCardInteractable, ProfileCardViewControllable>, ProfileCardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileCardInteractable, viewController: ProfileCardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
