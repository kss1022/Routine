//
//  RoutineHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RoutineHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineHomeComponent: Component<RoutineHomeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineHomeBuildable: Buildable {
    func build(withListener listener: RoutineHomeListener) -> RoutineHomeRouting
}

final class RoutineHomeBuilder: Builder<RoutineHomeDependency>, RoutineHomeBuildable {

    override init(dependency: RoutineHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineHomeListener) -> RoutineHomeRouting {
        let component = RoutineHomeComponent(dependency: dependency)
        let viewController = RoutineHomeViewController()
        let interactor = RoutineHomeInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineHomeRouter(interactor: interactor, viewController: viewController)
    }
}
