//
//  SettingFontInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/18/23.
//

import ModernRIBs

protocol SettingFontRouting: ViewableRouting {
    func attachSettingFontSize()
    func attachSettingTypeface()
}

protocol SettingFontPresentable: Presentable {
    var listener: SettingFontPresentableListener? { get set }
}

protocol SettingFontListener: AnyObject {
    func settingFontDidOnOSSize()
    func settingFontDidOffOSSize()
    func settingFontDidSetAppFontSize(appFontSize: AppFontSize)
    
    func settingFontOsTypefaceDidTap()
    func settingFontAppTypefaceDidTapBaseType()
}

final class SettingFontInteractor: PresentableInteractor<SettingFontPresentable>, SettingFontInteractable, SettingFontPresentableListener {

    weak var router: SettingFontRouting?
    weak var listener: SettingFontListener?

    // in constructor.
    override init(presenter: SettingFontPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachSettingFontSize()
        router?.attachSettingTypeface()        
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    
    //MARK: FontSize
    func settingFontSizeDidOnOSSize() {
        listener?.settingFontDidOnOSSize()
    }
    
    func settingFontSizeDidOffOSSize() {
        listener?.settingFontDidOffOSSize()
    }
    
    func settingFontSizeDidSetAppFontSize(appFontSize: AppFontSize) {
        listener?.settingFontDidSetAppFontSize(appFontSize: appFontSize)
    }

    //MARK: Typeface
    func settingTypefaceDidTapOS() {
        listener?.settingFontOsTypefaceDidTap()
    }
        
    func settingTypefaceDidTapBaseType() {
        listener?.settingFontAppTypefaceDidTapBaseType()
    }
    
}
