//
//  ProfileChartBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileChartDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileChartComponent: Component<ProfileChartDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileChartBuildable: Buildable {
    func build(withListener listener: ProfileChartListener) -> ProfileChartRouting
}

final class ProfileChartBuilder: Builder<ProfileChartDependency>, ProfileChartBuildable {

    override init(dependency: ProfileChartDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileChartListener) -> ProfileChartRouting {
        let component = ProfileChartComponent(dependency: dependency)
        let viewController = ProfileChartViewController()
        let interactor = ProfileChartInteractor(presenter: viewController)
        interactor.listener = listener
        return ProfileChartRouter(interactor: interactor, viewController: viewController)
    }
}
