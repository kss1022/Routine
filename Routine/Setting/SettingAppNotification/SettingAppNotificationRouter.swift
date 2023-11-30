//
//  SettingAppNotificationRouter.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol SettingAppNotificationInteractable: Interactable {
    var router: SettingAppNotificationRouting? { get set }
    var listener: SettingAppNotificationListener? { get set }
}

protocol SettingAppNotificationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingAppNotificationRouter: ViewableRouter<SettingAppNotificationInteractable, SettingAppNotificationViewControllable>, SettingAppNotificationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingAppNotificationInteractable, viewController: SettingAppNotificationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
