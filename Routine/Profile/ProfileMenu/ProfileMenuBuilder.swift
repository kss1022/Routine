//
//  ProfileMenuBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileMenuDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileMenuComponent: Component<ProfileMenuDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileMenuBuildable: Buildable {
    func build(withListener listener: ProfileMenuListener) -> ProfileMenuRouting
}

final class ProfileMenuBuilder: Builder<ProfileMenuDependency>, ProfileMenuBuildable {

    override init(dependency: ProfileMenuDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileMenuListener) -> ProfileMenuRouting {
        let component = ProfileMenuComponent(dependency: dependency)
        let viewController = ProfileMenuViewController()
        let interactor = ProfileMenuInteractor(presenter: viewController)
        interactor.listener = listener
        return ProfileMenuRouter(interactor: interactor, viewController: viewController)
    }
}
