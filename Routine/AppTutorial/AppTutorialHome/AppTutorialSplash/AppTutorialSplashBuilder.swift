//
//  AppTutorialSplashBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialSplashDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppTutorialSplashComponent: Component<AppTutorialSplashDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppTutorialSplashBuildable: Buildable {
    func build(withListener listener: AppTutorialSplashListener) -> AppTutorialSplashRouting
}

final class AppTutorialSplashBuilder: Builder<AppTutorialSplashDependency>, AppTutorialSplashBuildable {

    override init(dependency: AppTutorialSplashDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialSplashListener) -> AppTutorialSplashRouting {
        let component = AppTutorialSplashComponent(dependency: dependency)
        let viewController = AppTutorialSplashViewController()
        let interactor = AppTutorialSplashInteractor(presenter: viewController)
        interactor.listener = listener
        return AppTutorialSplashRouter(interactor: interactor, viewController: viewController)
    }
}
