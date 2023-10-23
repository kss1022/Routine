//
//  TimerSectionEditTitleBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleDependency: Dependency {
    var sectionList: TimerSectionListViewModel{ get }
}

final class TimerSectionEditTitleComponent: Component<TimerSectionEditTitleDependency>, TimerSectionEditTitleInteractorDependency {
    var sectionList: TimerSectionListViewModel{ dependency.sectionList}
}

// MARK: - Builder

protocol TimerSectionEditTitleBuildable: Buildable {
    func build(withListener listener: TimerSectionEditTitleListener) -> TimerSectionEditTitleRouting
}

final class TimerSectionEditTitleBuilder: Builder<TimerSectionEditTitleDependency>, TimerSectionEditTitleBuildable {

    override init(dependency: TimerSectionEditTitleDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditTitleListener) -> TimerSectionEditTitleRouting {
        let component = TimerSectionEditTitleComponent(dependency: dependency)
        let viewController = TimerSectionEditTitleViewController()
        let interactor = TimerSectionEditTitleInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerSectionEditTitleRouter(interactor: interactor, viewController: viewController)
    }
}
