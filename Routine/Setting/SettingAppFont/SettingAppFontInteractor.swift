//
//  SettingAppFontInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontRouting: ViewableRouting {
    func attachFontPicker()
    func detachFontPicker()
    
    func attachFontPreview()
    func attachFontSettingFont()
}

protocol SettingAppFontPresentable: Presentable {
    var listener: SettingAppFontPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol SettingAppFontListener: AnyObject {
    func settingAppFontDidMove()
}

final class SettingAppFontInteractor: PresentableInteractor<SettingAppFontPresentable>, SettingAppFontInteractable, SettingAppFontPresentableListener, AdaptivePresentationControllerDelegate {
    
    
    weak var router: SettingAppFontRouting?
    weak var listener: SettingAppFontListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    // in constructor.
    override init(presenter: SettingAppFontPresentable) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presentationDelegateProxy.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                        
        router?.attachFontPreview()
        router?.attachFontSettingFont()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        router?.detachFontPicker()
    }
    
    func didMove() {
        listener?.settingAppFontDidMove()
    }
    
    
    
    //MARK: Setting Font Size
    func settingFontSetOsSize() {
        Log.v("SettingFont Set OS Size")
        AppFontManager.share.setOfDynamicSize()
    }
    
    func settingFontSetCustomSize(value: Float) {
        Log.v("SettingFont Set Custom Size: \(value)")
        AppFontManager.share.setCustomFontSize(size: value)
    }
    
    //MARK: Setting Font Typeface
    func settingFontOsTypefaceDidTap() {
        router?.attachFontPicker()
    }
    
    func settingFontAppTypefaceDidTap(fontName: String) {
        Log.v("settingFontAppTypefaceDidTap: \(fontName)")
    }
    
    
    func fontPikcerDidPickFont(familyName: String) {
        try! AppFontManager.share.updateFont(familyName: familyName)
        
        router?.detachFontPicker()
    }
    
    func fontPickerDidTapCancel() {
        router?.detachFontPicker()
    }
}
