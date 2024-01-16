//
//  TimerSectionEditTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleDependency: Dependency {
}

final class TimerSectionEditTitleComponent: Component<TimerSectionEditTitleDependency>, TimerSectionEditTitleInteractorDependency {    
}

// MARK: - Builder

protocol TimerSectionEditTitleBuildable: Buildable {
    func build(withListener listener: TimerSectionEditTitleListener, emoji: String, name: String, description: String) -> TimerSectionEditTitleRouting
}

final class TimerSectionEditTitleBuilder: Builder<TimerSectionEditTitleDependency>, TimerSectionEditTitleBuildable {

    override init(dependency: TimerSectionEditTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditTitleListener, emoji: String, name: String, description: String) -> TimerSectionEditTitleRouting {
        let component = TimerSectionEditTitleComponent(dependency: dependency)
        let viewController = TimerSectionEditTitleViewController()
        let interactor = TimerSectionEditTitleInteractor(
            presenter: viewController,
            dependency: component,
            emoji: emoji,
            name: name,
            description: description
        )
        interactor.listener = listener
        return TimerSectionEditTitleRouter(interactor: interactor, viewController: viewController)
    }
}
