//
//  RoutineImojiIconBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineImojiIconDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineImojiIconComponent: Component<RoutineImojiIconDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RoutineImojiIconBuildable: Buildable {
    func build(withListener listener: RoutineImojiIconListener) -> RoutineImojiIconRouting
}

final class RoutineImojiIconBuilder: Builder<RoutineImojiIconDependency>, RoutineImojiIconBuildable {

    override init(dependency: RoutineImojiIconDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineImojiIconListener) -> RoutineImojiIconRouting {
        let component = RoutineImojiIconComponent(dependency: dependency)
        let viewController = RoutineImojiIconViewController()
        let interactor = RoutineImojiIconInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineImojiIconRouter(interactor: interactor, viewController: viewController)
    }
}
