//
//  SettingAppIconInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppIconRouting: ViewableRouting {
}

protocol SettingAppIconPresentable: Presentable {
    var listener: SettingAppIconPresentableListener? { get set }
    func setIcons(viewModels: [SettingAppIconViewModel])
}

protocol SettingAppIconListener: AnyObject {
    func settingAppIconDidMove()
}

final class SettingAppIconInteractor: PresentableInteractor<SettingAppIconPresentable>, SettingAppIconInteractable, SettingAppIconPresentableListener {

    weak var router: SettingAppIconRouting?
    weak var listener: SettingAppIconListener?

    // in constructor.
    override init(presenter: SettingAppIconPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setIcons(viewModels: [
            SettingAppIconViewModel(image: "kingfisher-2.jpg"),
            SettingAppIconViewModel(image: "kingfisher-3.jpg"),
            SettingAppIconViewModel(image: "kingfisher-4.jpg"),
            SettingAppIconViewModel(image: "kingfisher-5.jpg"),
            SettingAppIconViewModel(image: "kingfisher-6.jpg"),
            SettingAppIconViewModel(image: "kingfisher-7.jpg"),
            SettingAppIconViewModel(image: "kingfisher-8.jpg"),
            SettingAppIconViewModel(image: "kingfisher-9.jpg"),
        ])
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didMove() {
        listener?.settingAppIconDidMove()
    }
    
    func didSelectItemAt(row: Int) {
        //AppThemeManager.share.setLightMode()
    }
}
