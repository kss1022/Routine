//
//  AppFontListBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppFontListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppFontListComponent: Component<AppFontListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppFontListBuildable: Buildable {
    func build(withListener listener: AppFontListListener) -> AppFontListRouting
}

final class AppFontListBuilder: Builder<AppFontListDependency>, AppFontListBuildable {

    override init(dependency: AppFontListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppFontListListener) -> AppFontListRouting {
        let component = AppFontListComponent(dependency: dependency)
        let viewController = AppFontListViewController()
        let interactor = AppFontListInteractor(presenter: viewController)
        interactor.listener = listener
        return AppFontListRouter(interactor: interactor, viewController: viewController)
    }
}
