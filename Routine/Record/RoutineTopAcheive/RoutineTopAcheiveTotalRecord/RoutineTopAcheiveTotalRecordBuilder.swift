//
//  RoutineTopAcheiveTotalRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveTotalRecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RoutineTopAcheiveTotalRecordComponent: Component<RoutineTopAcheiveTotalRecordDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = RoutineTopAcheiveTotalRecordInteractor(presenter: viewController)
        interactor.listener = listener
        return RoutineTopAcheiveTotalRecordRouter(interactor: interactor, viewController: viewController)
    }
}
