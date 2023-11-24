//
//  ProfileHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol ProfileHomeInteractable: Interactable,ProfileEditListener, SettingAppAlarmListener, SettingAppThemeListener,  SettingAppFontListener, SettingAppIconListener, AppGuideListener, FeedbackMailListener, AppInfoListener, ProfileCardListener, ProfileStatListener, ProfileMenuListener {
    var router: ProfileHomeRouting? { get set }
    var listener: ProfileHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy{ get }
}

protocol ProfileHomeViewControllable: ViewControllable {
    func setProfileCard(_ view: ViewControllable)
    func setProfileStat(_ view: ViewControllable)
    func setProfileMenus(_ view: ViewControllable)
}

final class ProfileHomeRouter: ViewableRouter<ProfileHomeInteractable, ProfileHomeViewControllable>, ProfileHomeRouting {
    
    private let profileEditBuildable: ProfileEditBuildable
    private var profileEditRouting: ProfileEditRouting?
    
    
    private let settingAppAlarmBuildable: SettingAppAlarmBuildable
    private var settingAppAlarmRouter: Routing?

    private let settingAppThemeBuildable: SettingAppThemeBuildable
    private var settingAppThemeRouter: Routing?
    
    private let settingAppFontBuildable: SettingAppFontBuildable
    private var settingAppFontRouter: Routing?
    
    private let settingAppIconBuildable: SettingAppIconBuildable
    private var settingAppIconRouter: Routing?
    
    private let appGuideBuildable: AppGuideBuilder
    private var appGuideRouter: Routing?
    
    private let feedbackMailBuildable: FeedbackMailBuildable
    private var feedbackMailRouter: Routing?
    
    private let appInfoBuildable: AppInfoBuildable
    private var appInfoRouter: Routing?
    
    private let profileCardBuildable: ProfileCardBuildable
    private var profileCardRouter: Routing?
    
    private let profileStatBuildable: ProfileStatBuildable
    private var profileStatRouter: Routing?
    
    private let profileMenuBuildable: ProfileMenuBuildable
    private var profileMenuRouter: Routing?
    
    init(
        interactor: ProfileHomeInteractable,
        viewController: ProfileHomeViewControllable,
        profileEditBuildable: ProfileEditBuildable,
        settingAppAlarmBuildable: SettingAppAlarmBuildable,
        settingAppThemeBuildable: SettingAppThemeBuildable,
        settingAppFontBuildable: SettingAppFontBuildable,
        settingAppIconBuildable: SettingAppIconBuildable,
        appGuideBuildable: AppGuideBuilder,
        feedbackMailBuildable: FeedbackMailBuildable,
        appInfoBuildable: AppInfoBuildable,
        profileCardBuildable: ProfileCardBuildable,
        profileStatBuildable: ProfileStatBuildable,
        profileMenuBuildable: ProfileMenuBuildable
    ) {
        self.profileEditBuildable = profileEditBuildable
        self.settingAppAlarmBuildable =  settingAppAlarmBuildable
        self.settingAppThemeBuildable = settingAppThemeBuildable
        self.settingAppFontBuildable = settingAppFontBuildable
        self.settingAppIconBuildable = settingAppIconBuildable
        self.appGuideBuildable = appGuideBuildable
        self.feedbackMailBuildable = feedbackMailBuildable
        self.appInfoBuildable = appInfoBuildable
        self.profileCardBuildable = profileCardBuildable
        self.profileStatBuildable = profileStatBuildable
        self.profileMenuBuildable = profileMenuBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachProfileEdit() {
        if profileEditRouting != nil{
            return
        }
        
        let router = profileEditBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)        
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        profileEditRouting = router
        attachChild(router)
    }
    
    func detachProfileEdit() {
        guard let router = profileEditRouting else { return }
        
        viewController.dismiss(completion: nil)
        detachChild(router)
        profileEditRouting = nil
    }
    
    func attachSettingAppAlarm() {
        if settingAppAlarmRouter != nil{
            return
        }
        
        let router = settingAppAlarmBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        settingAppAlarmRouter = router
        attachChild(router)
    }
    
    func detachSettingAppAlarm() {
        guard let router = settingAppAlarmRouter else { return }
        
        detachChild(router)
        settingAppAlarmRouter = nil
    }
    
    func attachSettingAppTheme() {
        if settingAppThemeRouter != nil{
            return
        }
        
        let router = settingAppThemeBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        settingAppThemeRouter = router
        attachChild(router)
    }
    
    func detachSettingAppTheme() {
        guard let router = settingAppThemeRouter else { return }
        
        detachChild(router)
        settingAppThemeRouter = nil
    }
    
    func attachSettingAppFont() {
        if settingAppFontRouter != nil{
            return
        }
        
        let router = settingAppFontBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        settingAppFontRouter = router
        attachChild(router)
    }
    
    func detachSettingAppFont() {
        guard let router = settingAppFontRouter else { return }
        
        detachChild(router)
        settingAppFontRouter = nil
    }
    
    func attachSettingAppIcon() {
        if settingAppIconRouter != nil{
            return
        }
        
        let router = settingAppIconBuildable.build(withListener: interactor)
        viewController.pushViewController(router.viewControllable, animated: true)
        
        settingAppIconRouter = router
        attachChild(router)
    }
    
    func detachSettingAppIcon() {
        guard let router = settingAppIconRouter else { return }
        
        detachChild(router)
        settingAppIconRouter = nil
    }
    
    func attachAppGuide() {
        if appGuideRouter != nil{
            return
        }
        
        let router = appGuideBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        appGuideRouter = router
        attachChild(router)
    }
    
    func detachAppGuide() {
        guard let router = appGuideRouter else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        appGuideRouter = nil
    }
    
    func attachFeedbackMail() {
        if feedbackMailRouter != nil{
            return
        }
        
        let router = feedbackMailBuildable.build(withListener: interactor)
        
        let viewControllable = router.viewControllable
        viewControllable.uiviewController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(viewControllable, animated: true, completion: nil)
        
        feedbackMailRouter = router
        attachChild(router)
    }
    
    func detachFeedbackMail() {
        guard let router = feedbackMailRouter else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        feedbackMailRouter = nil
    }
    
    
    func attachAppInfo() {
        if appInfoRouter != nil{
            return
        }
        
        let router = appInfoBuildable.build(withListener: interactor)
        
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewController.present(navigation, animated: true, completion: nil)
        
        appInfoRouter = router
        attachChild(router)
    }
    
    func detachAppInfo() {
        guard let router = appInfoRouter else { return }
        viewController.dismiss(completion: nil)
        detachChild(router)
        appInfoRouter = nil
    }
    
   
    func attachProfileCard() {
        if profileCardRouter != nil{
            return
        }
        
        let router = profileCardBuildable.build(withListener: interactor)
        viewController.setProfileCard(router.viewControllable)
        
        profileCardRouter = router
        attachChild(router)
    }
    
    func attachProfileStat() {
        if profileStatRouter != nil{
            return
        }
        
        let router = profileStatBuildable.build(withListener: interactor)
        viewController.setProfileStat(router.viewControllable)
        
        profileStatRouter = router
        attachChild(router)
    }
    
    func attachProfileMenu() {
        if profileMenuRouter != nil{
            return
        }
        
        let router = profileMenuBuildable.build(withListener: interactor)
        viewController.setProfileMenus(router.viewControllable)
        
        profileMenuRouter = router
        attachChild(router)
    }

}
