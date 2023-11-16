//
//  SettingAppAlarmInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingAppAlarmPresentable: Presentable {
    var listener: SettingAppAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingAppAlarmListener: AnyObject {
    func settingAppAlarmDidMove()
}

final class SettingAppAlarmInteractor: PresentableInteractor<SettingAppAlarmPresentable>, SettingAppAlarmInteractable, SettingAppAlarmPresentableListener {

    weak var router: SettingAppAlarmRouting?
    weak var listener: SettingAppAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingAppAlarmPresentable) {
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
        listener?.settingAppAlarmDidMove()
    }
}
