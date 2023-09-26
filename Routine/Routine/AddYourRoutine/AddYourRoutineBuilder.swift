//
//  AddYourRoutineBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol AddYourRoutineDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AddYourRoutineComponent: Component<AddYourRoutineDependency>, RoutineTitleDependency, RoutineTintDependency, RoutineImojiIconDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AddYourRoutineBuildable: Buildable {
    func build(withListener listener: AddYourRoutineListener) -> AddYourRoutineRouting
}

final class AddYourRoutineBuilder: Builder<AddYourRoutineDependency>, AddYourRoutineBuildable {

    override init(dependency: AddYourRoutineDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddYourRoutineListener) -> AddYourRoutineRouting {
        let component = AddYourRoutineComponent(dependency: dependency)
        let viewController = AddYourRoutineViewController()
        let interactor = AddYourRoutineInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineTitleBuilder = RoutineTitleBuilder(dependency: component)
        let routineTintBuilder = RoutineTintBuilder(dependency: component)
        let routineImojiIconBuilder = RoutineImojiIconBuilder(dependency: component)
        
        return AddYourRoutineRouter(
            interactor: interactor,
            viewController: viewController,
            routineTitleBuildable: routineTitleBuilder,
            routineTintBuildable: routineTintBuilder,
            routineImojiIconBuildable: routineImojiIconBuilder
        )
    }
}
