//
//  CreateRoutineBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import ModernRIBs
import Combine

protocol CreateRoutineDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
}

final class CreateRoutineComponent: Component<CreateRoutineDependency> ,AddYourRoutineDependency, CreateRoutineInteractorDependency{    
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService}
    var routineRepository: RoutineRepository{ dependency.routineRepository }
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
        let interactor = CreateRoutineInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let addYourRoutineBuilder = AddYourRoutineBuilder(dependency: component)
        
        return CreateRoutineRouter(
            interactor: interactor,
            viewController: viewController,
            addYourRoutineBuildable: addYourRoutineBuilder
        )
    }
}
