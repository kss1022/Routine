//
//  RoutineEditReminderBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import ModernRIBs

protocol RoutineEditReminderDependency: Dependency {
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditReminderComponent: Component<RoutineEditReminderDependency> , RoutineEditReminderInteractorDependency{
    var detail: RoutineDetailModel?{ dependency.detail }
}

// MARK: - Builder

protocol RoutineEditReminderBuildable: Buildable {
    func build(withListener listener: RoutineEditReminderListener) -> RoutineEditReminderRouting
}

final class RoutineEditReminderBuilder: Builder<RoutineEditReminderDependency>, RoutineEditReminderBuildable {

    override init(dependency: RoutineEditReminderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditReminderListener) -> RoutineEditReminderRouting {
        let component = RoutineEditReminderComponent(dependency: dependency)
        let viewController = RoutineEditReminderViewController()
        let interactor = RoutineEditReminderInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEditReminderRouter(interactor: interactor, viewController: viewController)
    }
}
