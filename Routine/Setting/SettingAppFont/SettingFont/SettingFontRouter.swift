//
//  SettingFontRouter.swift
//  Routine
//
//  Created by 한현규 on 11/18/23.
//

import ModernRIBs

protocol SettingFontInteractable: Interactable, SettingFontSizeListener, SettingTypefaceListener {
    var router: SettingFontRouting? { get set }
    var listener: SettingFontListener? { get set }
}

protocol SettingFontViewControllable: ViewControllable {
    func setSettingFontSize(_ view: ViewControllable)
    func setSettingTypeface(_ view: ViewControllable)
}

final class SettingFontRouter: ViewableRouter<SettingFontInteractable, SettingFontViewControllable>, SettingFontRouting {

    
    private let settingFontSizeBuildable: SettingFontSizeBuildable
    private var settingFontSizeRouting: Routing?
    
    private let settingTypefaceBuildable: SettingTypefaceBuildable
    private var settingTypefaceRouting: Routing?
    
    init(
        interactor: SettingFontInteractable,
        viewController: SettingFontViewControllable,
        settingFontSizeBuildable: SettingFontSizeBuildable,
        settingTypefaceBuildable: SettingTypefaceBuildable
    ) {
        self.settingFontSizeBuildable = settingFontSizeBuildable
        self.settingTypefaceBuildable = settingTypefaceBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSettingFontSize() {
        if settingFontSizeRouting != nil{
            return
        }
        
        let router = settingFontSizeBuildable.build(withListener: interactor)
        viewController.setSettingFontSize(router.viewControllable)
        
        settingFontSizeRouting = router
        attachChild(router)
    }
    
    func attachSettingTypeface() {
        if settingTypefaceRouting != nil{
           return
        }
        
        let router = settingTypefaceBuildable.build(withListener: interactor)
        viewController.setSettingTypeface(router.viewControllable)
        
        settingTypefaceRouting = router
        attachChild(router)
    }
    
}
