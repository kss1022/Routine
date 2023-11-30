//
//  AppTutorialRoutineBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialRoutineDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
}

final class AppTutorialRoutineComponent: Component<AppTutorialRoutineDependency>, AppTutorialRoutineInteractorDependency {
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
}

// MARK: - Builder

protocol AppTutorialRoutineBuildable: Buildable {
    func build(withListener listener: AppTutorialRoutineListener) -> AppTutorialRoutineRouting
}

final class AppTutorialRoutineBuilder: Builder<AppTutorialRoutineDependency>, AppTutorialRoutineBuildable {

    override init(dependency: AppTutorialRoutineDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialRoutineListener) -> AppTutorialRoutineRouting {
        let component = AppTutorialRoutineComponent(dependency: dependency)
        let viewController = AppTutorialRoutineViewController()
        let interactor = AppTutorialRoutineInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AppTutorialRoutineRouter(interactor: interactor, viewController: viewController)
    }
}
