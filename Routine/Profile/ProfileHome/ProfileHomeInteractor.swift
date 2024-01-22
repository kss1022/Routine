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
    
    func attachSettingAppNotification()
    func detachSettingAppNotification()
    
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
    func attachProfileMenu()
}

protocol ProfileHomePresentable: Presentable {
    var listener: ProfileHomePresentableListener? { get set }
    
    func showError(title: String, message: String)
    func showMailResult(title: String, message: String)
}

protocol ProfileHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol ProfileHomeInteractorDependency{
    var profileRepository: ProfileRepository{ get }
}

final class ProfileHomeInteractor: PresentableInteractor<ProfileHomePresentable>, ProfileHomeInteractable, ProfileHomePresentableListener, AdaptivePresentationControllerDelegate {

    weak var router: ProfileHomeRouting?
    weak var listener: ProfileHomeListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: ProfileHomeInteractorDependency

    private var isEditProfile: Bool
    private var isAppGuide: Bool
    private var isFeedBack: Bool
    private var isAppInfo: Bool

    // in constructor.
    init(
        presenter: ProfileHomePresentable,
        dependency: ProfileHomeInteractorDependency
    ) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
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
        router?.attachProfileMenu()
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.profileRepository.fetchProfile()
            }catch{                
                Log.e(error.localizedDescription)
                await showFetchProfileFailed()
            }
        }
        
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
        router?.attachSettingAppNotification()
    }
    
    func settingAppNotificationDidMove() {
        router?.detachSettingAppNotification()
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
        if AppMailManager.shared.canSendMail(){
            isFeedBack = true
            router?.attachFeedbackMail()
        }else{
            Log.v("Mail Serive is no available")
            presenter.showError(
                title: "oops".localized(tableName: "Profile"),
                message: "mail_serive_no_available".localized(tableName: "Profile")
            )
        }
    }
    
    func feedbackMailDidFinishWithSaved() {
        router?.detachFeedbackMail()
        presenter.showMailResult(
            title: "saved_draft_folder".localized(tableName: "Profile"),
            message: "saved_draft_folder_message".localized(tableName: "Profile")
        )
    }
    
    func feedbackMailDidFinishWithSent() {
        router?.detachFeedbackMail()
        presenter.showMailResult(
            title: "send_feedback".localized(tableName: "Profile"),
            message: "thank_for_feedback".localized(tableName: "Profile")
        )
    }
    
    func feedbackMailDidFinishWithFail() {
        router?.detachFeedbackMail()
        presenter.showMailResult(
            title: "send_feedback".localized(tableName: "Profile"),
            message: "send_mail_fail".localized(tableName: "Profile")
        )
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


private extension ProfileHomeInteractor{
    @MainActor
    func showFetchProfileFailed(){
        let title = "try_again_later".localized(tableName: "Profile")
        let message = "fetch_profile_failed".localized(tableName: "Profile")
        presenter.showError(title: title, message: message)
    }
}
