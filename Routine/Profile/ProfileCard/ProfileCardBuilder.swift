//
//  ProfileCardBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import ModernRIBs

protocol ProfileCardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileCardComponent: Component<ProfileCardDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileCardBuildable: Buildable {
    func build(withListener listener: ProfileCardListener) -> ProfileCardRouting
}

final class ProfileCardBuilder: Builder<ProfileCardDependency>, ProfileCardBuildable {

    override init(dependency: ProfileCardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileCardListener) -> ProfileCardRouting {
        let component = ProfileCardComponent(dependency: dependency)
        let viewController = ProfileCardViewController()
        let interactor = ProfileCardInteractor(presenter: viewController)
        interactor.listener = listener
        return ProfileCardRouter(interactor: interactor, viewController: viewController)
    }
}
