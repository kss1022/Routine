//
//  SettingAppAlarmBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingAppAlarmComponent: Component<SettingAppAlarmDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingAppAlarmBuildable: Buildable {
    func build(withListener listener: SettingAppAlarmListener) -> SettingAppAlarmRouting
}

final class SettingAppAlarmBuilder: Builder<SettingAppAlarmDependency>, SettingAppAlarmBuildable {

    override init(dependency: SettingAppAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingAppAlarmListener) -> SettingAppAlarmRouting {
        let component = SettingAppAlarmComponent(dependency: dependency)
        let viewController = SettingAppAlarmViewController()
        let interactor = SettingAppAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingAppAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
