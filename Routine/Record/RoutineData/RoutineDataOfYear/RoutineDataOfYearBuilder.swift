//
//  RoutineDataOfYearBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfYearDependency: Dependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ get }
}

final class RoutineDataOfYearComponent: Component<RoutineDataOfYearDependency>, RoutineDataOfYearInteractorDependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordModel?>{ dependency.routineRecords }    
}

// MARK: - Builder

protocol RoutineDataOfYearBuildable: Buildable {
    func build(withListener listener: RoutineDataOfYearListener) -> RoutineDataOfYearRouting
}

final class RoutineDataOfYearBuilder: Builder<RoutineDataOfYearDependency>, RoutineDataOfYearBuildable {

    override init(dependency: RoutineDataOfYearDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfYearListener) -> RoutineDataOfYearRouting {
        let component = RoutineDataOfYearComponent(dependency: dependency)
        let viewController = RoutineDataOfYearViewController()
        let interactor = RoutineDataOfYearInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineDataOfYearRouter(interactor: interactor, viewController: viewController)
    }
}
