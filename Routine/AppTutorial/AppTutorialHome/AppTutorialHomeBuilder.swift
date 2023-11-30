//
//  AppTutorialHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import ModernRIBs

protocol AppTutorialHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppTutorialHomeComponent: Component<AppTutorialHomeDependency>, AppTutorialMainDependency, AppTutorialSplashDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppTutorialHomeBuildable: Buildable {
    func build(withListener listener: AppTutorialHomeListener) -> AppTutorialHomeRouting
}

final class AppTutorialHomeBuilder: Builder<AppTutorialHomeDependency>, AppTutorialHomeBuildable {

    override init(dependency: AppTutorialHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialHomeListener) -> AppTutorialHomeRouting {
        let component = AppTutorialHomeComponent(dependency: dependency)
        let viewController = AppTutorialHomeViewController()
        let interactor = AppTutorialHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let appTutorialMainBuilder = AppTutorialMainBuilder(dependency: component)
        let appTutorialSplashBuilder = AppTutorialSplashBuilder(dependency: component)
        
        return AppTutorialHomeRouter(
            interactor: interactor,
            viewController: viewController,
            appTutorailMainBuildable: appTutorialMainBuilder,
            appTutorailSplashBuildable: appTutorialSplashBuilder
        )
    }
}
