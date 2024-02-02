//
//  AppTutorialMainBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMainDependency: Dependency {
}

final class AppTutorialMainComponent: Component<AppTutorialMainDependency> {
}

// MARK: - Builder

protocol AppTutorialMainBuildable: Buildable {
    func build(withListener listener: AppTutorialMainListener) -> AppTutorialMainRouting
}

final class AppTutorialMainBuilder: Builder<AppTutorialMainDependency>, AppTutorialMainBuildable {

    override init(dependency: AppTutorialMainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialMainListener) -> AppTutorialMainRouting {
        let component = AppTutorialMainComponent(dependency: dependency)
        let viewController = AppTutorialMainViewController()
        let interactor = AppTutorialMainInteractor(presenter: viewController)
        interactor.listener = listener
        return AppTutorialMainRouter(interactor: interactor, viewController: viewController)
    }
}
