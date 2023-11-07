//
//  RoutineTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineTotalRecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTotalRecordComponent: Component<RoutineTotalRecordDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineTotalRecordBuildable: Buildable {
    func build(withListener listener: RoutineTotalRecordListener) -> RoutineTotalRecordRouting
}

final class RoutineTotalRecordBuilder: Builder<RoutineTotalRecordDependency>, RoutineTotalRecordBuildable {

    override init(dependency: RoutineTotalRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTotalRecordListener) -> RoutineTotalRecordRouting {
        let component = RoutineTotalRecordComponent(dependency: dependency)
        let viewController = RoutineTotalRecordViewController()
        let interactor = RoutineTotalRecordInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
