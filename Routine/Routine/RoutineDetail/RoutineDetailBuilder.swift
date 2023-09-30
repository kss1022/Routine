//
//  RoutineDetailBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineDetailComponent: Component<RoutineDetailDependency>, RoutineTitleDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineDetailBuildable: Buildable {
    func build(withListener listener: RoutineDetailListener) -> RoutineDetailRouting
}

final class RoutineDetailBuilder: Builder<RoutineDetailDependency>, RoutineDetailBuildable {

    override init(dependency: RoutineDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDetailListener) -> RoutineDetailRouting {
        let component = RoutineDetailComponent(dependency: dependency)
        let viewController = RoutineDetailViewController()
        let interactor = RoutineDetailInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineTitleBuilder = RoutineTitleBuilder(dependency: component)
        
        return RoutineDetailRouter(
            interactor: interactor,
            viewController: viewController,
            routineTitleBuildable: routineTitleBuilder
        )
    }
}
