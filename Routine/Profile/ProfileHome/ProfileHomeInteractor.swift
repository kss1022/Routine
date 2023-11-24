//
//  ProfileHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol ProfileHomeRouting: ViewableRouting {
    func attachProfileEdit()
    func detachProfileEdit()
    
    func attachSettingAppAlarm()
    func detachSettingAppAlarm()
    
    func attachSettingAppTheme()
    func detachSettingAppTheme()
    
    func attachSettingAppFont()
    func detachSettingAppFont()
    
    func attachSettingAppIcon()
    func detachSettingAppIcon()
    
    func attachAppGuide()
    func detachAppGuide()
    
    func attachFeedbackMail()
    func detachFeedbackMail()
    
    func attachAppInfo()
    func detachAppInfo()
    
    func attachProfileCard()
    func attachProfileStat()
    func attachProfileMenu()
}

protocol ProfileHomePresentable: Presentable {
    var listener: ProfileHomePresentableListener? { get set }
    func showMailResult(title: String, message: String)
}

protocol ProfileHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileHomeInteractor: PresentableInteractor<ProfileHomePresentable>, ProfileHomeInteractable, ProfileHomePresentableListener, AdaptivePresentationControllerDelegate {

    weak var router: ProfileHomeRouting?
    weak var listener: ProfileHomeListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    var isEditProfile: Bool
    var isAppGuide: Bool
    var isFeedBack: Bool
    var isAppInfo: Bool

    // in constructor.
    override init(presenter: ProfileHomePresentable) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        isEditProfile = false
        isAppGuide = false
        isFeedBack = false
        isAppInfo = false
        super.init(presenter: presenter)
        presenter.listener = self
        presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Log.v("Profile Home DidBecome Active 🧑🏻‍💻")
        
        router?.attachProfileCard()
        //router?.attachProfileStat()
        router?.attachProfileMenu()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    
    func presentationControllerDidDismiss() {
        if isEditProfile{
            router?.detachProfileEdit()
            isEditProfile = false
            return
        }
        
        if isAppGuide{
            router?.detachAppGuide()
            isAppGuide = false
            return
        }
        
        if isFeedBack{
            router?.detachFeedbackMail()
            isFeedBack = false
            return
        }
        
        if isAppInfo{
            router?.detachAppInfo()
            isAppInfo = false
            return
        }        
    }
    
    
    //MARK: ProfileEdit
    func profileCardProfileMemojiViewDidTap() {
        isEditProfile = true
        router?.attachProfileEdit()
    }
    
    func profileEditCloseButtonDidTap() {
        isEditProfile = false
        router?.detachProfileEdit()
    }
    
    //MARK: AppAlarm
    func profileMenuAlarmButtonDidTap() {
        router?.attachSettingAppAlarm()
    }
    
    func settingAppAlarmDidMove() {
        router?.detachSettingAppAlarm()
    }
    
    //MARK: AppTheme
    func profileMenuThemeButtonDidTap() {
        router?.attachSettingAppTheme()
    }
    
    func settingAppThemeDidMove() {
        router?.detachSettingAppTheme()
    }
    
    //MARK: AppFont
    func profileMenuFontButtonDidTap() {
        router?.attachSettingAppFont()
    }
    
    func settingAppFontDidMove() {
        router?.detachSettingAppFont()
    }
    
    //MARK: AppIcon
    func profileMenuAppIconButtonDidTap() {
        router?.attachSettingAppIcon()
    }
    
    func settingAppIconDidMove() {
        router?.detachSettingAppIcon()
    }
    
    //MARK: Guide
    func profileMenuGuideButtonDidTap() {
        isAppGuide = true
        router?.attachAppGuide()
    }
    
    func appGuideCloseButtonDidTap() {
        isAppGuide = false
        router?.detachAppGuide()
    }
    
    //MARK: FeedbackMail
    func profileMenuFeedbackButtonDidTap() {
        if AppMailManager.share.canSendMail(){
            isFeedBack = true
            router?.attachFeedbackMail()
        }else{
            Log.v("Mail Serive is no available")
        }
    }
    
    func feedbackMailDidFinishWithSaved() {
        router?.detachFeedbackMail()
        presenter.showMailResult(title: "Saved in Draft Folder", message: "The drafted email has been saved in the draft folder.")
    }
    
    func feedbackMailDidFinishWithSent() {
        router?.detachFeedbackMail()
        presenter.showMailResult(title: "Send Feedback", message: "Thank you for your feedback🙏")
    }
    
    func feedbackMailDidFinishWithFail() {
        router?.detachFeedbackMail()
        presenter.showMailResult(title: "Send Feedback", message: "Send Mail Fail😰")
    }
        
    func feedbackMailDidFinishWithCancel() {
        router?.detachFeedbackMail()
    }
    
    
    //MARK: AppInfo
    func profileMenuAppInfoButtonDidTap() {
        isAppInfo = true
        router?.attachAppInfo()
    }
    
    func appInfoCloseButtonDidTap() {
        isAppInfo = false
        router?.detachAppInfo()
    }
    
    func profileMenuRequestReviewDidTap() {
        let appstoreid = URLSchemeManager.RoutineAppStoreAppId
        AppRequestReviewManager().openAppStoreReview(appStoreAppID: appstoreid)
    }

   
}
