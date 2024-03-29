//
//  ProfileHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol ProfileHomeDependency: Dependency {
    var profileApplicationService: ProfileApplicationService{ get }
    
    var reminderRepository: ReminderRepository{ get }
    var profileRepository: ProfileRepository{ get }
}

final class ProfileHomeComponent: Component<ProfileHomeDependency>,ProfileEditDependency, SettingAppNotificationDependency, SettingAppThemeDependency, SettingAppFontDependency, SettingAppIconDependency, AppGuideDependency, FeedbackMailDependency, AppInfoDependency, ProfileCardDependency, ProfileMenuDependency, ProfileHomeInteractorDependency {
    
    
    var profileApplicationService: ProfileApplicationService{ dependency.profileApplicationService }
    
    var reminderRepository: ReminderRepository{ dependency.reminderRepository }
    var profileRepository: ProfileRepository{ dependency.profileRepository }
    
    var profile: ReadOnlyCurrentValuePublisher<ProfileModel?>{ profileRepository.profile }
}

// MARK: - Builder

protocol ProfileHomeBuildable: Buildable {
    func build(withListener listener: ProfileHomeListener) -> ProfileHomeRouting
}

final class ProfileHomeBuilder: Builder<ProfileHomeDependency>, ProfileHomeBuildable {

    override init(dependency: ProfileHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileHomeListener) -> ProfileHomeRouting {
        let component = ProfileHomeComponent(dependency: dependency)
        let viewController = ProfileHomeViewController()
        let interactor = ProfileHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        
        let profileEditBuilder = ProfileEditBuilder(dependency: component)
        
        let settingAppNotificationBuilder = SettingAppNotificationBuilder(dependency: component)
        let settingAppThemeBuilder = SettingAppThemeBuilder(dependency: component)
        let settingAppFontBuilder = SettingAppFontBuilder(dependency: component)
        let settingAppIconBuilder = SettingAppIconBuilder(dependency: component)
        
        let appGuideBuilder = AppGuideBuilder(dependency: component)
        let feedbackMailBuilder = FeedbackMailBuilder(dependency: component)
        let appInfoBuilder = AppInfoBuilder(dependency: component)
        
        let profileCardBuilder = ProfileCardBuilder(dependency: component)
        let profileMenuBuilder = ProfileMenuBuilder(dependency: component)
        
        return ProfileHomeRouter(
            interactor: interactor,
            viewController: viewController,
            profileEditBuildable: profileEditBuilder,
            settingAppNotificationBuildable: settingAppNotificationBuilder,
            settingAppThemeBuildable: settingAppThemeBuilder,
            settingAppFontBuildable: settingAppFontBuilder,
            settingAppIconBuildable: settingAppIconBuilder,
            appGuideBuildable: appGuideBuilder,
            feedbackMailBuildable: feedbackMailBuilder,
            appInfoBuildable: appInfoBuilder,
            profileCardBuildable: profileCardBuilder,
            profileMenuBuildable: profileMenuBuilder
        )
    }
}
