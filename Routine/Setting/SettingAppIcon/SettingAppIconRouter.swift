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
}

final class SettingAppIconRouter: ViewableRouter<SettingAppIconInteractable, SettingAppIconViewControllable>, SettingAppIconRouting {

    override init(interactor: SettingAppIconInteractable, viewController: SettingAppIconViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
