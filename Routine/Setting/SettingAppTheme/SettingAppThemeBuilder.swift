//
//  SettingAppThemeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppThemeDependency: Dependency {
}

final class SettingAppThemeComponent: Component<SettingAppThemeDependency> {
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
