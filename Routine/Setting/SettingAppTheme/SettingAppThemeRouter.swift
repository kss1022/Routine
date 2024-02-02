//
//  SettingAppThemeRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppThemeInteractable: Interactable {
    var router: SettingAppThemeRouting? { get set }
    var listener: SettingAppThemeListener? { get set }
}

protocol SettingAppThemeViewControllable: ViewControllable {
}

final class SettingAppThemeRouter: ViewableRouter<SettingAppThemeInteractable, SettingAppThemeViewControllable>, SettingAppThemeRouting {

    override init(interactor: SettingAppThemeInteractable, viewController: SettingAppThemeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
