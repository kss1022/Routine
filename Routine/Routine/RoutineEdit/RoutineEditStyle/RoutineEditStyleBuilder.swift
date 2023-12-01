//
//  RoutineEditStyleBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import ModernRIBs

protocol RoutineEditStyleDependency: Dependency {
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditStyleComponent: Component<RoutineEditStyleDependency>, RoutineEditStyleInteractorDependency {
    var detail: RoutineDetailModel?{ dependency.detail }
}

// MARK: - Builder

protocol RoutineEditStyleBuildable: Buildable {
    func build(withListener listener: RoutineEditStyleListener) -> RoutineEditStyleRouting
}

final class RoutineEditStyleBuilder: Builder<RoutineEditStyleDependency>, RoutineEditStyleBuildable {

    override init(dependency: RoutineEditStyleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditStyleListener) -> RoutineEditStyleRouting {
        let component = RoutineEditStyleComponent(dependency: dependency)
        let viewController = RoutineEditStyleViewController()
        let interactor = RoutineEditStyleInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEditStyleRouter(interactor: interactor, viewController: viewController)
    }
}
