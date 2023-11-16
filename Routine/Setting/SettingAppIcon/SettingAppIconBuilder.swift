//
//  SettingAppIconBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol SettingAppIconDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingAppIconComponent: Component<SettingAppIconDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
