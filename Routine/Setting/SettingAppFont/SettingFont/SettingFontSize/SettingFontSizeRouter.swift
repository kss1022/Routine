//
//  SettingFontSizeRouter.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingFontSizeInteractable: Interactable {
    var router: SettingFontSizeRouting? { get set }
    var listener: SettingFontSizeListener? { get set }
}

protocol SettingFontSizeViewControllable: ViewControllable {
}

final class SettingFontSizeRouter: ViewableRouter<SettingFontSizeInteractable, SettingFontSizeViewControllable>, SettingFontSizeRouting {

    override init(interactor: SettingFontSizeInteractable, viewController: SettingFontSizeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
