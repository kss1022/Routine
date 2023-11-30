//
//  AppRootBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol AppRootDependency: Dependency {
    
}


// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
        let viewController = AppRootViewController()
        
        let component = AppRootComponent(
            dependency: dependency,
            viewController: viewController
        )
        
                        
        let interactor = AppRootInteractor(presenter: viewController, dependency: component)
        
        let appHomeBuilder = AppHomeBuilder(dependency: component)
        let appTutorailBuilder = AppTutorialBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: viewController,
            appHomeBuildable: appHomeBuilder,
            appTutorailBuildable: appTutorailBuilder
        )
        
        return (router , interactor)
    }
}
