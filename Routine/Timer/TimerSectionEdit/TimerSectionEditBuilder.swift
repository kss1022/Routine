//
//  TimerSectionEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TimerSectionEditComponent: Component<TimerSectionEditDependency>, TimerSectionEditTitleDependency, TimerSectionEditValueDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TimerSectionEditBuildable: Buildable {
    func build(withListener listener: TimerSectionEditListener) -> TimerSectionEditRouting
}

final class TimerSectionEditBuilder: Builder<TimerSectionEditDependency>, TimerSectionEditBuildable {

    override init(dependency: TimerSectionEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditListener) -> TimerSectionEditRouting {
        let component = TimerSectionEditComponent(dependency: dependency)
        let viewController = TimerSectionEditViewController()
        let interactor = TimerSectionEditInteractor(presenter: viewController)
        interactor.listener = listener
        
        let timerSectionEditTitleBuilder = TimerSectionEditTitleBuilder(dependency: component)
        let timerSectionEditValueBuilder = TimerSectionEditValueBuilder(dependency: component)
        
        
        return TimerSectionEditRouter(
            interactor: interactor,
            viewController: viewController,
            timerSectionEditTitleBuildable: timerSectionEditTitleBuilder,
            timerSectionEditValueBuildable: timerSectionEditValueBuilder
        )
    }
}
