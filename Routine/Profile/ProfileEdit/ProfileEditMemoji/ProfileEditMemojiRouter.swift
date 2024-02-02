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
}

final class ProfileEditMemojiRouter: ViewableRouter<ProfileEditMemojiInteractable, ProfileEditMemojiViewControllable>, ProfileEditMemojiRouting {

    override init(interactor: ProfileEditMemojiInteractable, viewController: ProfileEditMemojiViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
