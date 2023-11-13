//
//  RecordTimerListBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import ModernRIBs

protocol RecordTimerListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RecordTimerListComponent: Component<RecordTimerListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RecordTimerListBuildable: Buildable {
    func build(withListener listener: RecordTimerListListener) -> RecordTimerListRouting
}

final class RecordTimerListBuilder: Builder<RecordTimerListDependency>, RecordTimerListBuildable {

    override init(dependency: RecordTimerListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordTimerListListener) -> RecordTimerListRouting {
        let component = RecordTimerListComponent(dependency: dependency)
        let viewController = RecordTimerListViewController()
        let interactor = RecordTimerListInteractor(presenter: viewController)
        interactor.listener = listener
        return RecordTimerListRouter(interactor: interactor, viewController: viewController)
    }
}
