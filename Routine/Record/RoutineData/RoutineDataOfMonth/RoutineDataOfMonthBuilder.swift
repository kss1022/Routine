//
//  RoutineDataOfMonthBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfMonthDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineDataOfMonthComponent: Component<RoutineDataOfMonthDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineDataOfMonthBuildable: Buildable {
    func build(withListener listener: RoutineDataOfMonthListener) -> RoutineDataOfMonthRouting
}

final class RoutineDataOfMonthBuilder: Builder<RoutineDataOfMonthDependency>, RoutineDataOfMonthBuildable {

    override init(dependency: RoutineDataOfMonthDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfMonthListener) -> RoutineDataOfMonthRouting {
        let component = RoutineDataOfMonthComponent(dependency: dependency)
        let viewController = RoutineDataOfMonthViewController()
        let interactor = RoutineDataOfMonthInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineDataOfMonthRouter(interactor: interactor, viewController: viewController)
    }
}
