//
//  RoutineTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineTotalRecordDependency: Dependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ get }
}

final class RoutineTotalRecordComponent: Component<RoutineTotalRecordDependency>, RoutineTotalRecordInteractorDependency{
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ dependency.routineRecords }
}

// MARK: - Builder

protocol RoutineTotalRecordBuildable: Buildable {
    func build(withListener listener: RoutineTotalRecordListener) -> RoutineTotalRecordRouting
}

final class RoutineTotalRecordBuilder: Builder<RoutineTotalRecordDependency>, RoutineTotalRecordBuildable {

    override init(dependency: RoutineTotalRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTotalRecordListener) -> RoutineTotalRecordRouting {
        let component = RoutineTotalRecordComponent(dependency: dependency)
        let viewController = RoutineTotalRecordViewController()
        let interactor = RoutineTotalRecordInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
