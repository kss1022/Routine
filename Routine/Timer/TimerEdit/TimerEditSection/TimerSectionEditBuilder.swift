//
//  TimerSectionEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditDependency: Dependency {
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class TimerSectionEditComponent: Component<TimerSectionEditDependency>, TimerSectionEditTitleDependency, TimerSectionEditTimeDependency, TimerSectionEditRepeatDependency, TimerSectionEditInteractorDependency {
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ dependency.sectionListsSubject}
}

// MARK: - Builder

protocol TimerSectionEditBuildable: Buildable {
    func build(withListener listener: TimerSectionEditListener, sectionList: TimerSectionListModel) -> TimerSectionEditRouting
}

final class TimerSectionEditBuilder: Builder<TimerSectionEditDependency>, TimerSectionEditBuildable {

    override init(dependency: TimerSectionEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditListener, sectionList: TimerSectionListModel) -> TimerSectionEditRouting {
        let component = TimerSectionEditComponent(dependency: dependency)
        let viewController = TimerSectionEditViewController()
        let interactor = TimerSectionEditInteractor(presenter: viewController, dependency: component, sectionList: sectionList)
        interactor.listener = listener
        
        let timerSectionEditTitleBuilder = TimerSectionEditTitleBuilder(dependency: component)
        let timerSectionEidtTimeBuilder = TimerSectionEditTimeBuilder(dependency: component)
        let timerSectionEditRepeatBuilder = TimerSectionEditRepeatBuilder(dependency: component)
        
        
        return TimerSectionEditRouter(
            interactor: interactor,
            viewController: viewController,
            timerSectionEditTitleBuildable: timerSectionEditTitleBuilder,
            timerSectionEditTimeBuildable: timerSectionEidtTimeBuilder,
            timerSectionEditRepeatBuildable: timerSectionEditRepeatBuilder
        )
    }
}
