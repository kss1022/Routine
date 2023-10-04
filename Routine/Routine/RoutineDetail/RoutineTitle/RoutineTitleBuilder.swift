//
//  RoutineTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs

protocol RoutineTitleDependency: Dependency {
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ get }
}

final class RoutineTitleComponent: Component<RoutineTitleDependency>, RoutineTitleInteractorDependency {
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ dependency.routineDetail }
}

// MARK: - Builder

protocol RoutineTitleBuildable: Buildable {
    func build(withListener listener: RoutineTitleListener) -> RoutineTitleRouting
}

final class RoutineTitleBuilder: Builder<RoutineTitleDependency>, RoutineTitleBuildable {

    override init(dependency: RoutineTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTitleListener) -> RoutineTitleRouting {
        let component = RoutineTitleComponent(dependency: dependency)
        let viewController = RoutineTitleViewController()
        let interactor = RoutineTitleInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineTitleRouter(interactor: interactor, viewController: viewController)
    }
}
