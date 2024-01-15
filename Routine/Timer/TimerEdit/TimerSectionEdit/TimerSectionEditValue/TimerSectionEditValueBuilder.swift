//
//  TimerSectionEditValueBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol TimerSectionEditValueDependency: Dependency {
    var sectionList: TimerSectionListViewModel{ get }
}

final class TimerSectionEditValueComponent: Component<TimerSectionEditValueDependency>, TimerSectionEditValueInteractorDependency {
    var sectionList: TimerSectionListViewModel{ dependency.sectionList}
}

// MARK: - Builder

protocol TimerSectionEditValueBuildable: Buildable {
    func build(withListener listener: TimerSectionEditValueListener) -> TimerSectionEditValueRouting
}

final class TimerSectionEditValueBuilder: Builder<TimerSectionEditValueDependency>, TimerSectionEditValueBuildable {

    override init(dependency: TimerSectionEditValueDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditValueListener) -> TimerSectionEditValueRouting {
        let component = TimerSectionEditValueComponent(dependency: dependency)
        let viewController = TimerSectionEditValueViewController()
        let interactor = TimerSectionEditValueInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerSectionEditValueRouter(interactor: interactor, viewController: viewController)
    }
}
