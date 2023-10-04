//
//  RoutineTintBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs

protocol RoutineTintDependency: Dependency {
    var routineRepository : RoutineRepository { get }

    var tintSubject: CurrentValuePublisher<String>{ get }
}

final class RoutineTintComponent: Component<RoutineTintDependency>, RoutineTintInteractorDependency {
    var routineRepository : RoutineRepository { dependency.routineRepository }

    var tintSubject: CurrentValuePublisher<String>{ dependency.tintSubject }
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
        let interactor = RoutineTintInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        return RoutineTintRouter(interactor: interactor, viewController: viewController)
    }
}
