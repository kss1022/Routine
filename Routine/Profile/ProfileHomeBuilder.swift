//
//  ProfileHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol ProfileHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileHomeComponent: Component<ProfileHomeDependency>, SettingAppAlarmDependency, SettingAppThemeDependency, SettingAppFontDependency, SettingAppIconDependency, AppGuideDependency, FeedbackMailDependency, AppInfoDependency, ProfileCardDependency, ProfileStatDependency, ProfileMenuDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = ProfileHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        
        let settingAppAlarmBuilder = SettingAppAlarmBuilder(dependency: component)
        let settingAppThemeBuilder = SettingAppThemeBuilder(dependency: component)
        let settingAppFontBuilder = SettingAppFontBuilder(dependency: component)
        let settingAppIconBuilder = SettingAppIconBuilder(dependency: component)
        
        let appGuideBuilder = AppGuideBuilder(dependency: component)
        let feedbackMailBuilder = FeedbackMailBuilder(dependency: component)
        let appInfoBuilder = AppInfoBuilder(dependency: component)
        
        let profileCardBuilder = ProfileCardBuilder(dependency: component)
        let profileStatBuilder = ProfileStatBuilder(dependency: component)
        let profileMenuBuilder = ProfileMenuBuilder(dependency: component)
        
        return ProfileHomeRouter(
            interactor: interactor,
            viewController: viewController,
            settingAppAlarmBuildable: settingAppAlarmBuilder,
            settingAppThemeBuildable: settingAppThemeBuilder,
            settingAppFontBuildable: settingAppFontBuilder,
            settingAppIconBuildable: settingAppIconBuilder,
            appGuideBuildable: appGuideBuilder,
            feedbackMailBuildable: feedbackMailBuilder,
            appInfoBuildable: appInfoBuilder,
            profileCardBuildable: profileCardBuilder,
            profileStatBuildable: profileStatBuilder,
            profileMenuBuildable: profileMenuBuilder
        )
    }
}
