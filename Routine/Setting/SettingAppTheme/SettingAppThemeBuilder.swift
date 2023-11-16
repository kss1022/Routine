//
//  SettingAppThemeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppThemeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingAppThemeComponent: Component<SettingAppThemeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingAppThemeBuildable: Buildable {
    func build(withListener listener: SettingAppThemeListener) -> SettingAppThemeRouting
}

final class SettingAppThemeBuilder: Builder<SettingAppThemeDependency>, SettingAppThemeBuildable {

    override init(dependency: SettingAppThemeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingAppThemeListener) -> SettingAppThemeRouting {
        let component = SettingAppThemeComponent(dependency: dependency)
        let viewController = SettingAppThemeViewController()
        let interactor = SettingAppThemeInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingAppThemeRouter(interactor: interactor, viewController: viewController)
    }
}
