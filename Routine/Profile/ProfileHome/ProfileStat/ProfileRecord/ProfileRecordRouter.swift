//
//  ProfileRecordRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileRecordInteractable: Interactable {
    var router: ProfileRecordRouting? { get set }
    var listener: ProfileRecordListener? { get set }
}

protocol ProfileRecordViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ProfileRecordRouter: ViewableRouter<ProfileRecordInteractable, ProfileRecordViewControllable>, ProfileRecordRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ProfileRecordInteractable, viewController: ProfileRecordViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
