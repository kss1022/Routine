//
//  SettingAppNotificationBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol SettingAppNotificationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingAppNotificationComponent: Component<SettingAppNotificationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingAppNotificationBuildable: Buildable {
    func build(withListener listener: SettingAppNotificationListener) -> SettingAppNotificationRouting
}

final class SettingAppNotificationBuilder: Builder<SettingAppNotificationDependency>, SettingAppNotificationBuildable {

    override init(dependency: SettingAppNotificationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingAppNotificationListener) -> SettingAppNotificationRouting {
        let component = SettingAppNotificationComponent(dependency: dependency)
        let viewController = SettingAppNotificationViewController()
        let interactor = SettingAppNotificationInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingAppNotificationRouter(interactor: interactor, viewController: viewController)
    }
}
