//
//  SettingAppAlarmRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppAlarmInteractable: Interactable {
    var router: SettingAppAlarmRouting? { get set }
    var listener: SettingAppAlarmListener? { get set }
}

protocol SettingAppAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingAppAlarmRouter: ViewableRouter<SettingAppAlarmInteractable, SettingAppAlarmViewControllable>, SettingAppAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingAppAlarmInteractable, viewController: SettingAppAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
