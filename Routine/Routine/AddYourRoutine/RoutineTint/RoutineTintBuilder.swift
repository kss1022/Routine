//
//  RoutineTintBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineTintDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTintComponent: Component<RoutineTintDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineTintBuildable: Buildable {
    func build(withListener listener: RoutineTintListener) -> RoutineTintRouting
}

final class RoutineTintBuilder: Builder<RoutineTintDependency>, RoutineTintBuildable {

    override init(dependency: RoutineTintDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTintListener) -> RoutineTintRouting {
        let component = RoutineTintComponent(dependency: dependency)
        let viewController = RoutineTintViewController()
        let interactor = RoutineTintInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineTintRouter(interactor: interactor, viewController: viewController)
    }
}
