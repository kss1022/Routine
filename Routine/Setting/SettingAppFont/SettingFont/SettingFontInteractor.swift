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
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingFontListener: AnyObject {
    func settingFontSetOsSize()
    func settingFontSetCustomSize(value: Float)
    
    func settingFontOsTypefaceDidTap()
    func settingFontAppTypefaceDidTapBaseType()
}

final class SettingFontInteractor: PresentableInteractor<SettingFontPresentable>, SettingFontInteractable, SettingFontPresentableListener {

    weak var router: SettingFontRouting?
    weak var listener: SettingFontListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
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
        // TODO: Pause any business logic.
    }
    
    func segmentControlDidTap(index: Int) {
        
    }
    
    
    //MARK: FontSize
    func settingFontSizeSetOsSize() {
        listener?.settingFontSetOsSize()
    }
    
    func settingFontSizeSetCustomSize(value: Float) {
        listener?.settingFontSetCustomSize(value: value)
    }

    //MARK: Typeface
    func settingTypefaceDidTapOS() {
        listener?.settingFontOsTypefaceDidTap()
    }
        
    func settingTypefaceDidTapBaseType() {
        listener?.settingFontAppTypefaceDidTapBaseType()
    }
    
}
