//
//  SettingAppNotificationBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs

protocol SettingAppNotificationDependency: Dependency {
    var reminderRepository: ReminderRepository{ get }
}

final class SettingAppNotificationComponent: Component<SettingAppNotificationDependency>, SettingAppNotificationInteractorDependency {
    var reminderRepository: ReminderRepository{ dependency.reminderRepository }
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
        let interactor = SettingAppNotificationInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SettingAppNotificationRouter(interactor: interactor, viewController: viewController)
    }
}
