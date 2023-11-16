//
//  SettingAppIconRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppIconInteractable: Interactable {
    var router: SettingAppIconRouting? { get set }
    var listener: SettingAppIconListener? { get set }
}

protocol SettingAppIconViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingAppIconRouter: ViewableRouter<SettingAppIconInteractable, SettingAppIconViewControllable>, SettingAppIconRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingAppIconInteractable, viewController: SettingAppIconViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
