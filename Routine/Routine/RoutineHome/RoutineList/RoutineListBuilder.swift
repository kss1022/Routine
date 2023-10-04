//
//  RoutineListBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import ModernRIBs

protocol RoutineListDependency: Dependency {
    var routineRepository: RoutineRepository{ get }
}

final class RoutineListComponent: Component<RoutineListDependency>, RoutineListInteractorDependency {
    var routineRepository: RoutineRepository{ dependency.routineRepository }
}

// MARK: - Builder

protocol RoutineListBuildable: Buildable {
    func build(withListener listener: RoutineListListener) -> RoutineListRouting
}

final class RoutineListBuilder: Builder<RoutineListDependency>, RoutineListBuildable {

    override init(dependency: RoutineListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineListListener) -> RoutineListRouting {
        let component = RoutineListComponent(dependency: dependency)
        let viewController = RoutineListViewController()
        let interactor = RoutineListInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        return RoutineListRouter(interactor: interactor, viewController: viewController)
    }
}
