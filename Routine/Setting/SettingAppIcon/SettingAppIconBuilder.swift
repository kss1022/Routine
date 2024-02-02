//
//  SettingAppIconBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppIconDependency: Dependency {
}

final class SettingAppIconComponent: Component<SettingAppIconDependency> {
}

// MARK: - Builder

protocol SettingAppIconBuildable: Buildable {
    func build(withListener listener: SettingAppIconListener) -> SettingAppIconRouting
}

final class SettingAppIconBuilder: Builder<SettingAppIconDependency>, SettingAppIconBuildable {

    override init(dependency: SettingAppIconDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingAppIconListener) -> SettingAppIconRouting {
        let component = SettingAppIconComponent(dependency: dependency)
        let viewController = SettingAppIconViewController()
        let interactor = SettingAppIconInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingAppIconRouter(interactor: interactor, viewController: viewController)
    }
}
