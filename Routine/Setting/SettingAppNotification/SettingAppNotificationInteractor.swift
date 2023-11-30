//
//  SettingAppNotificationInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol SettingAppNotificationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingAppNotificationPresentable: Presentable {
    var listener: SettingAppNotificationPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingAppNotificationListener: AnyObject {
    func settingAppNotificationDidMove()
}

final class SettingAppNotificationInteractor: PresentableInteractor<SettingAppNotificationPresentable>, SettingAppNotificationInteractable, SettingAppNotificationPresentableListener {

    weak var router: SettingAppNotificationRouting?
    weak var listener: SettingAppNotificationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingAppNotificationPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMove() {
        listener?.settingAppNotificationDidMove()
    }
}
