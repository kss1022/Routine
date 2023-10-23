//
//  TimerSectionListBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionListDependency: Dependency {
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class TimerSectionListComponent: Component<TimerSectionListDependency>, TimerSectionListInternalDependency {
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ dependency.sectionLists }
}

// MARK: - Builder

protocol TimerSectionListBuildable: Buildable {
    func build(withListener listener: TimerSectionListListener) -> TimerSectionListRouting
}

final class TimerSectionListBuilder: Builder<TimerSectionListDependency>, TimerSectionListBuildable {

    override init(dependency: TimerSectionListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TimerSectionListListener) -> TimerSectionListRouting {
        let component = TimerSectionListComponent(dependency: dependency)
        let viewController = TimerSectionListViewController()
        let interactor = TimerSectionListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TimerSectionListRouter(interactor: interactor, viewController: viewController)
    }
}
