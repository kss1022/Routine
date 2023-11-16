//
//  AppGuideBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol AppGuideDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppGuideComponent: Component<AppGuideDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppGuideBuildable: Buildable {
    func build(withListener listener: AppGuideListener) -> AppGuideRouting
}

final class AppGuideBuilder: Builder<AppGuideDependency>, AppGuideBuildable {

    override init(dependency: AppGuideDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppGuideListener) -> AppGuideRouting {
        let component = AppGuideComponent(dependency: dependency)
        let viewController = AppGuideViewController()
        let interactor = AppGuideInteractor(presenter: viewController)
        interactor.listener = listener
        return AppGuideRouter(interactor: interactor, viewController: viewController)
    }
}
