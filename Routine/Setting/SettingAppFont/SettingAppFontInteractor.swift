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
}

protocol SettingAppFontListener: AnyObject {
    func settingAppFontDidMove()
}

protocol SettingAppFontInteractorDependency{
    var isOSTypefcaeSubject: CurrentValuePublisher<Bool>{ get }
    var oSFontNameSubject: CurrentValuePublisher<String>{ get }
    
    var isOsFontSizeSubject: CurrentValuePublisher<Bool>{ get }
    var fontSizeSubject: CurrentValuePublisher<AppFontSize>{ get }
}

final class SettingAppFontInteractor: PresentableInteractor<SettingAppFontPresentable>, SettingAppFontInteractable, SettingAppFontPresentableListener, AdaptivePresentationControllerDelegate {
    
    
    weak var router: SettingAppFontRouting?
    weak var listener: SettingAppFontListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: SettingAppFontInteractorDependency
    
    private let isOSTypefcaeSubject: CurrentValuePublisher<Bool>
    private let oSFontNameSubject: CurrentValuePublisher<String>
    
    private let isOsFontSizeSubject: CurrentValuePublisher<Bool>
    private let fontSizeSubject: CurrentValuePublisher<AppFontSize>
    
    
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
        self.isOsFontSizeSubject = dependency.isOsFontSizeSubject
        self.fontSizeSubject = dependency.fontSizeSubject
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
    }
    
    func presentationControllerDidDismiss() {
        router?.detachFontPicker()
    }
    
    func didMove() {
        listener?.settingAppFontDidMove()
    }
    
    
    
    //MARK: Setting Font Size
    func settingFontDidOnOSSize() {
        appFontService.updateOSFontSize()
        isOsFontSizeSubject.send(appFontService.isOSFontSize)
    }
    
    func settingFontDidOffOSSize() {
        appFontService.updateAppFontSize()
        isOsFontSizeSubject.send(appFontService.isOSFontSize)
    }
    
    func settingFontDidSetAppFontSize(appFontSize: AppFontSize) {
        appFontService.updateAppFontSize(appFontSize)
        fontSizeSubject.send(appFontService.fontSize)
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
