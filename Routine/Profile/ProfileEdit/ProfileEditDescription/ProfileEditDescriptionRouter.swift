//
//  ProfileEditDescriptionRouter.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditDescriptionInteractable: Interactable {
    var router: ProfileEditDescriptionRouting? { get set }
    var listener: ProfileEditDescriptionListener? { get set }
}

protocol ProfileEditDescriptionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileEditDescriptionRouter: ViewableRouter<ProfileEditDescriptionInteractable, ProfileEditDescriptionViewControllable>, ProfileEditDescriptionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileEditDescriptionInteractable, viewController: ProfileEditDescriptionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
