//
//  AppInfoBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppInfoDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppInfoComponent: Component<AppInfoDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppInfoBuildable: Buildable {
    func build(withListener listener: AppInfoListener) -> AppInfoRouting
}

final class AppInfoBuilder: Builder<AppInfoDependency>, AppInfoBuildable {

    override init(dependency: AppInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppInfoListener) -> AppInfoRouting {
        let component = AppInfoComponent(dependency: dependency)
        let viewController = AppInfoViewController()
        let interactor = AppInfoInteractor(presenter: viewController)
        interactor.listener = listener
        return AppInfoRouter(interactor: interactor, viewController: viewController)
    }
}
