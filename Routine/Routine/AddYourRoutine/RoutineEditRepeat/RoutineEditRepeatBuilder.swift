//
//  RoutineEditRepeatBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditRepeatDependency: Dependency {
    var repeatTypeSubject: CurrentValuePublisher<RepeatTypeViewModel>{ get }
    var repeatValueSubject: CurrentValuePublisher<RepeatValueViewModel>{ get }
}

final class RoutineEditRepeatComponent: Component<RoutineEditRepeatDependency>, RoutineEditRepeatInteractorDependency {
    var repeatTypeSubject: CurrentValuePublisher<RepeatTypeViewModel>{ dependency.repeatTypeSubject }
    var repeatValueSubject: CurrentValuePublisher<RepeatValueViewModel>{ dependency.repeatValueSubject }
}

// MARK: - Builder

protocol RoutineEditRepeatBuildable: Buildable {
    func build(withListener listener: RoutineEditRepeatListener) -> RoutineEditRepeatRouting
}

final class RoutineEditRepeatBuilder: Builder<RoutineEditRepeatDependency>, RoutineEditRepeatBuildable {

    override init(dependency: RoutineEditRepeatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditRepeatListener) -> RoutineEditRepeatRouting {
        let component = RoutineEditRepeatComponent(dependency: dependency)
        let viewController = RoutineEditRepeatViewController()
        let interactor = RoutineEditRepeatInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEditRepeatRouter(interactor: interactor, viewController: viewController)
    }
}
