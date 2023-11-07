//
//  RoutineDataOfWeekBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfWeekDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineDataOfWeekComponent: Component<RoutineDataOfWeekDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineDataOfWeekBuildable: Buildable {
    func build(withListener listener: RoutineDataOfWeekListener) -> RoutineDataOfWeekRouting
}

final class RoutineDataOfWeekBuilder: Builder<RoutineDataOfWeekDependency>, RoutineDataOfWeekBuildable {

    override init(dependency: RoutineDataOfWeekDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfWeekListener) -> RoutineDataOfWeekRouting {
        let component = RoutineDataOfWeekComponent(dependency: dependency)
        let viewController = RoutineDataOfWeekViewController()
        let interactor = RoutineDataOfWeekInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineDataOfWeekRouter(interactor: interactor, viewController: viewController)
    }
}
