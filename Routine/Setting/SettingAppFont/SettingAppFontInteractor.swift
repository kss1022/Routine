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

protocol SettingAppFontInteractorDependency{
    var isOSTypefcaeSubject: CurrentValuePublisher<Bool>{ get }
    var oSFontNameSubject: CurrentValuePublisher<String>{ get }
}

final class SettingAppFontInteractor: PresentableInteractor<SettingAppFontPresentable>, SettingAppFontInteractable, SettingAppFontPresentableListener, AdaptivePresentationControllerDelegate {
    
    
    weak var router: SettingAppFontRouting?
    weak var listener: SettingAppFontListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: SettingAppFontInteractorDependency
    
    private let isOSTypefcaeSubject: CurrentValuePublisher<Bool>
    private let oSFontNameSubject: CurrentValuePublisher<String>
    
    
    private let appFontService: AppFontService
    
    // in constructor.
    init(
        presenter: SettingAppFontPresentable,
        dependency: SettingAppFontInteractorDependency
    ) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        self.isOSTypefcaeSubject = dependency.isOSTypefcaeSubject
        self.oSFontNameSubject = dependency.oSFontNameSubject
        self.appFontService = AppFontService.shared
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
        //AppFontService.shared.setOfDynamicSize()
    }
    
    func settingFontSetCustomSize(value: Float) {
        Log.v("SettingFont Set Custom Size: \(value)")
        //AppFontService.shared.setCustomFontSize(size: value)
    }
    
    //MARK: Setting Font Typeface
    func settingFontOsTypefaceDidTap() {
        router?.attachFontPicker()
    }
    
    func settingFontAppTypefaceDidTapBaseType() {
        appFontService.updateBaseFont()
        
        
        isOSTypefcaeSubject.send(appFontService.isOSTypeface)
        oSFontNameSubject.send(appFontService.fontName)
    }
    
    
    //MARK: FontPicker
    func fontPikcerDidPickFont(familyName: String) {
        appFontService.updateFont(familyName: familyName)
        isOSTypefcaeSubject.send(appFontService.isOSTypeface)
        oSFontNameSubject.send(appFontService.fontName)
        
        router?.detachFontPicker()
    }
            
    func fontPickerDidTapCancel() {
        router?.detachFontPicker()
    }
}
