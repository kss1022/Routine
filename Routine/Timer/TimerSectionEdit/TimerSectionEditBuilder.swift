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

final class TimerSectionEditComponent: Component<TimerSectionEditDependency>, TimerSectionEditTitleDependency, TimerSectionEditValueDependency, TimerSectionEditInteractorDependency {
    
    var sectionList: TimerSectionListViewModel
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ dependency.sectionListsSubject }

    
    init(dependency: TimerSectionEditDependency, sectionList: TimerSectionListViewModel) {
        self.sectionList = sectionList
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol TimerSectionEditBuildable: Buildable {
    func build(withListener listener: TimerSectionEditListener, sectionList: TimerSectionListViewModel) -> TimerSectionEditRouting
}

final class TimerSectionEditBuilder: Builder<TimerSectionEditDependency>, TimerSectionEditBuildable {

    override init(dependency: TimerSectionEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionEditListener, sectionList: TimerSectionListViewModel) -> TimerSectionEditRouting {
        let component = TimerSectionEditComponent(dependency: dependency, sectionList: sectionList)
        let viewController = TimerSectionEditViewController()
        let interactor = TimerSectionEditInteractor(presenter: viewController, dependency: component)
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
