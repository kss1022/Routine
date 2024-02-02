//
//  SettingTypefaceRouter.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingTypefaceInteractable: Interactable {
    var router: SettingTypefaceRouting? { get set }
    var listener: SettingTypefaceListener? { get set }
}

protocol SettingTypefaceViewControllable: ViewControllable {
}

final class SettingTypefaceRouter: ViewableRouter<SettingTypefaceInteractable, SettingTypefaceViewControllable>, SettingTypefaceRouting {

    override init(interactor: SettingTypefaceInteractable, viewController: SettingTypefaceViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
