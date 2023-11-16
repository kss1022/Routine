//
//  ProfileAcheiveBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileAcheiveDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileAcheiveComponent: Component<ProfileAcheiveDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileAcheiveBuildable: Buildable {
    func build(withListener listener: ProfileAcheiveListener) -> ProfileAcheiveRouting
}

final class ProfileAcheiveBuilder: Builder<ProfileAcheiveDependency>, ProfileAcheiveBuildable {

    override init(dependency: ProfileAcheiveDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileAcheiveListener) -> ProfileAcheiveRouting {
        let component = ProfileAcheiveComponent(dependency: dependency)
        let viewController = ProfileAcheiveViewController()
        let interactor = ProfileAcheiveInteractor(presenter: viewController)
        interactor.listener = listener
        return ProfileAcheiveRouter(interactor: interactor, viewController: viewController)
    }
}
