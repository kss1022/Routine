//
//  RoutineEditTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEditTitleDependency: Dependency {
    var emoji: ReadOnlyCurrentValuePublisher<String>{ get }
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditTitleComponent: Component<RoutineEditTitleDependency> , RoutineEditTitleInteractorDependency{
    var emoji: ReadOnlyCurrentValuePublisher<String>{ dependency.emoji }
    var detail: RoutineDetailModel?{ dependency.detail }
}

// MARK: - Builder

protocol RoutineEditTitleBuildable: Buildable {
    func build(withListener listener: RoutineEditTitleListener) -> RoutineEditTitleRouting
}

final class RoutineEditTitleBuilder: Builder<RoutineEditTitleDependency>, RoutineEditTitleBuildable {

    override init(dependency: RoutineEditTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditTitleListener) -> RoutineEditTitleRouting {
        let component = RoutineEditTitleComponent(dependency: dependency)
        let viewController = RoutineEditTitleViewController()
        let interactor = RoutineEditTitleInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEditTitleRouter(interactor: interactor, viewController: viewController)
    }
}
