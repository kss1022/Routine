//
//  ProfileEditDescriptionBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditDescriptionDependency: Dependency {
    var profileDescriptionSubject: CurrentValuePublisher<String>{ get}
}

final class ProfileEditDescriptionComponent: Component<ProfileEditDescriptionDependency>, ProfileEditDescriptionInteractorDependency {
    var profileDescriptionSubject: CurrentValuePublisher<String>{ dependency.profileDescriptionSubject }
}

// MARK: - Builder

protocol ProfileEditDescriptionBuildable: Buildable {
    func build(withListener listener: ProfileEditDescriptionListener) -> ProfileEditDescriptionRouting
}

final class ProfileEditDescriptionBuilder: Builder<ProfileEditDescriptionDependency>, ProfileEditDescriptionBuildable {

    override init(dependency: ProfileEditDescriptionDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileEditDescriptionListener) -> ProfileEditDescriptionRouting {
        let component = ProfileEditDescriptionComponent(dependency: dependency)
        let viewController = ProfileEditDescriptionViewController()
        let interactor = ProfileEditDescriptionInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ProfileEditDescriptionRouter(interactor: interactor, viewController: viewController)
    }
}
