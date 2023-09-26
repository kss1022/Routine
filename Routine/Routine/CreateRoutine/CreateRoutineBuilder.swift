//
//  CreateRoutineBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import ModernRIBs

protocol CreateRoutineDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CreateRoutineComponent: Component<CreateRoutineDependency> , AddYourRoutineDependency{

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CreateRoutineBuildable: Buildable {
    func build(withListener listener: CreateRoutineListener) -> ViewableRouting
}

final class CreateRoutineBuilder: Builder<CreateRoutineDependency>, CreateRoutineBuildable {

    override init(dependency: CreateRoutineDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CreateRoutineListener) -> ViewableRouting {
        let component = CreateRoutineComponent(dependency: dependency)
        let viewController = CreateRoutineViewController()
        let interactor = CreateRoutineInteractor(presenter: viewController)
        interactor.listener = listener
        
        let addYourRoutineBuilder = AddYourRoutineBuilder(dependency: component)
        
        return CreateRoutineRouter(
            interactor: interactor,
            viewController: viewController,
            addYourRoutineBuildable: addYourRoutineBuilder
        )
    }
}
