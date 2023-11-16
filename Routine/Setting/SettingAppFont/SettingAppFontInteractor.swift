//
//  SettingAppFontInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingAppFontPresentable: Presentable {
    var listener: SettingAppFontPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingAppFontListener: AnyObject {
    func settingAppFontDidMove()
}

final class SettingAppFontInteractor: PresentableInteractor<SettingAppFontPresentable>, SettingAppFontInteractable, SettingAppFontPresentableListener {

    weak var router: SettingAppFontRouting?
    weak var listener: SettingAppFontListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingAppFontPresentable) {
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
        listener?.settingAppFontDidMove()
    }
}
