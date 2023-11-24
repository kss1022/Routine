//
//  ProfileEditMemojiRouter.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditMemojiInteractable: Interactable {
    var router: ProfileEditMemojiRouting? { get set }
    var listener: ProfileEditMemojiListener? { get set }
}

protocol ProfileEditMemojiViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileEditMemojiRouter: ViewableRouter<ProfileEditMemojiInteractable, ProfileEditMemojiViewControllable>, ProfileEditMemojiRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileEditMemojiInteractable, viewController: ProfileEditMemojiViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
