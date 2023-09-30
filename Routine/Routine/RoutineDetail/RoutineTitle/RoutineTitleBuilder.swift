//
//  RoutineTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineTitleDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTitleComponent: Component<RoutineTitleDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineTitleBuildable: Buildable {
    func build(withListener listener: RoutineTitleListener) -> RoutineTitleRouting
}

final class RoutineTitleBuilder: Builder<RoutineTitleDependency>, RoutineTitleBuildable {

    override init(dependency: RoutineTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTitleListener) -> RoutineTitleRouting {
        let component = RoutineTitleComponent(dependency: dependency)
        let viewController = RoutineTitleViewController()
        let interactor = RoutineTitleInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineTitleRouter(interactor: interactor, viewController: viewController)
    }
}
