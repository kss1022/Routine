//
//  RoutineTopAcheiveBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTopAcheiveComponent: Component<RoutineTopAcheiveDependency>, RoutineTopAcheiveChartDependency, RoutineTopAcheiveTotalRecordDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineTopAcheiveBuildable: Buildable {
    func build(withListener listener: RoutineTopAcheiveListener) -> RoutineTopAcheiveRouting
}

final class RoutineTopAcheiveBuilder: Builder<RoutineTopAcheiveDependency>, RoutineTopAcheiveBuildable {

    override init(dependency: RoutineTopAcheiveDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTopAcheiveListener) -> RoutineTopAcheiveRouting {
        let component = RoutineTopAcheiveComponent(dependency: dependency)
        let viewController = RoutineTopAcheiveViewController()
        let interactor = RoutineTopAcheiveInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineTopAcheiveBuilder = RoutineTopAcheiveChartBuilder(dependency: component)
        let routineTopAcheiveTotalRecordBuilder = RoutineTopAcheiveTotalRecordBuilder(dependency: component)
        
        return RoutineTopAcheiveRouter(
            interactor: interactor,
            viewController: viewController,
            routineTopAcheiveChartBuildable: routineTopAcheiveBuilder,
            routineTopAcheiveTotalRecordBuildable: routineTopAcheiveTotalRecordBuilder
        )
    }
}
