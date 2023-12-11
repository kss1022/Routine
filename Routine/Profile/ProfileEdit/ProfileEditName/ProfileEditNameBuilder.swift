//
//  ProfileEditNameBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditNameDependency: Dependency {
    var profileNameSubject: CurrentValuePublisher<String>{ get }
}

final class ProfileEditNameComponent: Component<ProfileEditNameDependency>, ProfileEditNameInteractorDependency {
    var profileNameSubject: CurrentValuePublisher<String>{ dependency.profileNameSubject }
}

// MARK: - Builder

protocol ProfileEditNameBuildable: Buildable {
    func build(withListener listener: ProfileEditNameListener) -> ProfileEditNameRouting
}

final class ProfileEditNameBuilder: Builder<ProfileEditNameDependency>, ProfileEditNameBuildable {

    override init(dependency: ProfileEditNameDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileEditNameListener) -> ProfileEditNameRouting {
        let component = ProfileEditNameComponent(dependency: dependency)
        let viewController = ProfileEditNameViewController()
        let interactor = ProfileEditNameInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ProfileEditNameRouter(interactor: interactor, viewController: viewController)
    }
}
