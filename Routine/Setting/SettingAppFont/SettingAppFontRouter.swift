//
//  SettingAppFontRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontInteractable: Interactable {
    var router: SettingAppFontRouting? { get set }
    var listener: SettingAppFontListener? { get set }
}

protocol SettingAppFontViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingAppFontRouter: ViewableRouter<SettingAppFontInteractable, SettingAppFontViewControllable>, SettingAppFontRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingAppFontInteractable, viewController: SettingAppFontViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
