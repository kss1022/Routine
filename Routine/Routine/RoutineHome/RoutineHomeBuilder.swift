//
//  RoutineHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RoutineHomeDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
}

final class RoutineHomeComponent: Component<RoutineHomeDependency> , RoutineHomeInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
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
        let interactor = RoutineHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineHomeRouter(interactor: interactor, viewController: viewController)
    }
}
