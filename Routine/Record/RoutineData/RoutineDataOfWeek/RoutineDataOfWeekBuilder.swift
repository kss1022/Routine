//
//  RoutineDataOfWeekBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfWeekDependency: Dependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ get }
}

final class RoutineDataOfWeekComponent: Component<RoutineDataOfWeekDependency>, RoutineDataOfWeekInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ dependency.routineRecords }
}

// MARK: - Builder

protocol RoutineDataOfWeekBuildable: Buildable {
    func build(withListener listener: RoutineDataOfWeekListener) -> RoutineDataOfWeekRouting
}

final class RoutineDataOfWeekBuilder: Builder<RoutineDataOfWeekDependency>, RoutineDataOfWeekBuildable {

    override init(dependency: RoutineDataOfWeekDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfWeekListener) -> RoutineDataOfWeekRouting {
        let component = RoutineDataOfWeekComponent(dependency: dependency)
        let viewController = RoutineDataOfWeekViewController()
        let interactor = RoutineDataOfWeekInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineDataOfWeekRouter(interactor: interactor, viewController: viewController)
    }
}
