//
//  SettingAppFontRouter.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontInteractable: Interactable, FontPickerListener, FontPreviewListener, SettingFontListener {
    var router: SettingAppFontRouting? { get set }
    var listener: SettingAppFontListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol SettingAppFontViewControllable: ViewControllable {
    func setFontPreview(_ view: ViewControllable)
    func setSettingFont(_ view: ViewControllable)
}

final class SettingAppFontRouter: ViewableRouter<SettingAppFontInteractable, SettingAppFontViewControllable>, SettingAppFontRouting {

    private let fontPickerBuildable: FontPickerBuildable
    private var fontPickerRouting: Routing?
    

    private let fontPreviewBuildable: FontPreviewBuildable
    private var fontPreviewRouting: Routing?
    
    private let settingFontBuildable: SettingFontBuildable
    private var settingFontRouting: Routing?
    
    
    init(
        interactor: SettingAppFontInteractable,
        viewController: SettingAppFontViewControllable,
        fontPickerBuildable: FontPickerBuildable,
        fontPreviewBuildable: FontPreviewBuildable,
        settingFontBuildable: SettingFontBuildable
    ) {
        self.fontPickerBuildable = fontPickerBuildable        
        self.fontPreviewBuildable = fontPreviewBuildable
        self.settingFontBuildable = settingFontBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachFontPicker() {
        if fontPickerRouting != nil{
            return
        }
        
        let router = fontPickerBuildable.build(withListener: interactor)
        let viewControllable = router.viewControllable
                
        viewControllable.uiviewController.presentationController?.delegate = interactor.presentationDelegateProxy
        
        viewController.present(viewControllable, animated: true, completion: nil)
        
        fontPickerRouting = router
        attachChild(router)
    }
    
    func detachFontPicker() {
        guard let router = fontPickerRouting else { return }
        viewController.dismiss(completion: nil)
        
        detachChild(router)
        fontPickerRouting = nil
    }
    
    
    func attachFontPreview() {
        if fontPreviewRouting != nil{
            return
        }
        
        let router = fontPreviewBuildable.build(withListener: interactor)
        viewController.setFontPreview(router.viewControllable)
        
        fontPreviewRouting = router
        attachChild(router)
    }
    
    func attachFontSettingFont() {
        if settingFontRouting != nil{
            return
        }
        
        let router = settingFontBuildable.build(withListener: interactor)
        viewController.setSettingFont(router.viewControllable)
        
        settingFontRouting = router
        attachChild(router)
    }

}
