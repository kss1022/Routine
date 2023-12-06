//
//  SettingAppThemeInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol SettingAppThemeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingAppThemePresentable: Presentable {
    var listener: SettingAppThemePresentableListener? { get set }
    func setSelectedRow(row: Int)
    func updateTheme()
}

protocol SettingAppThemeListener: AnyObject {
    func settingAppThemeDidMove()
}

final class SettingAppThemeInteractor: PresentableInteractor<SettingAppThemePresentable>, SettingAppThemeInteractable, SettingAppThemePresentableListener {
    
    weak var router: SettingAppThemeRouting?
    weak var listener: SettingAppThemeListener?

    private let appThemeManager: AppThemeManager
    
    // in constructor.
    override init(presenter: SettingAppThemePresentable) {
        self.appThemeManager = AppThemeManager.share
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        switch appThemeManager.theme {
        case .system: presenter.setSelectedRow(row: 0)
        case .light: presenter.setSelectedRow(row: 1)
        case .dark: presenter.setSelectedRow(row: 2)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMove() {
        listener?.settingAppThemeDidMove()
    }
    
    func tableViewDidSelectedRow(row: Int) {
        switch row{
        case 0:
            //system
            appThemeManager.setSystemMode()
            presenter.updateTheme()
        case 1:
            //light
            appThemeManager.setLightMode()
            presenter.updateTheme()
        case 2:
            //dark
            appThemeManager.setDarkMode()            
            presenter.updateTheme()
        default : fatalError("Invalid Selected Row")
        }                
    }

}
