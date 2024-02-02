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
}

final class SettingAppNotificationRouter: ViewableRouter<SettingAppNotificationInteractable, SettingAppNotificationViewControllable>, SettingAppNotificationRouting {

    override init(interactor: SettingAppNotificationInteractable, viewController: SettingAppNotificationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
