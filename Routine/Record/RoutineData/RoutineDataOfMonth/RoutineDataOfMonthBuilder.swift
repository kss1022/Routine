//
//  RoutineDataOfMonthBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataOfMonthDependency: Dependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ get }}

final class RoutineDataOfMonthComponent: Component<RoutineDataOfMonthDependency>, RoutineDataOfMonthInteractorDependency {
    var routineRecords: ReadOnlyCurrentValuePublisher<RoutineRecordDatasModel?>{ dependency.routineRecords }}

// MARK: - Builder

protocol RoutineDataOfMonthBuildable: Buildable {
    func build(withListener listener: RoutineDataOfMonthListener) -> RoutineDataOfMonthRouting
}

final class RoutineDataOfMonthBuilder: Builder<RoutineDataOfMonthDependency>, RoutineDataOfMonthBuildable {

    override init(dependency: RoutineDataOfMonthDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineDataOfMonthListener) -> RoutineDataOfMonthRouting {
        let component = RoutineDataOfMonthComponent(dependency: dependency)
        let viewController = RoutineDataOfMonthViewController()
        let interactor = RoutineDataOfMonthInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineDataOfMonthRouter(interactor: interactor, viewController: viewController)
    }
}
