//
//  ProfileCardBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import ModernRIBs

protocol ProfileCardDependency: Dependency {
    var profile: ReadOnlyCurrentValuePublisher<ProfileModel?>{ get }
}

final class ProfileCardComponent: Component<ProfileCardDependency>, ProfileCardInteractorDependency {
    var profile: ReadOnlyCurrentValuePublisher<ProfileModel?>{ dependency.profile }
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
        let interactor = ProfileCardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ProfileCardRouter(interactor: interactor, viewController: viewController)
    }
}
