//
//  RoutineTopAcheiveTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveTotalRecordDependency: Dependency {
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
}

final class RoutineTopAcheiveTotalRecordComponent: Component<RoutineTopAcheiveTotalRecordDependency>, RoutineTopAcheiveTotalRecordInteractorDependency {
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ dependency.topAcheives }
}

// MARK: - Builder

protocol RoutineTopAcheiveTotalRecordBuildable: Buildable {
    func build(withListener listener: RoutineTopAcheiveTotalRecordListener) -> RoutineTopAcheiveTotalRecordRouting
}

final class RoutineTopAcheiveTotalRecordBuilder: Builder<RoutineTopAcheiveTotalRecordDependency>, RoutineTopAcheiveTotalRecordBuildable {

    override init(dependency: RoutineTopAcheiveTotalRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTopAcheiveTotalRecordListener) -> RoutineTopAcheiveTotalRecordRouting {
        let component = RoutineTopAcheiveTotalRecordComponent(dependency: dependency)
        let viewController = RoutineTopAcheiveTotalRecordViewController()
        let interactor = RoutineTopAcheiveTotalRecordInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineTopAcheiveTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
