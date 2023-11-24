//
//  ProfileEditMemojiBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditMemojiDependency: Dependency {
    var profile: ProfileModel?{ get }
    var profileName: ReadOnlyCurrentValuePublisher<String>{ get }
    var profileDescription: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class ProfileEditMemojiComponent: Component<ProfileEditMemojiDependency>, ProfileEditMemojiInteractorDependency {
    var profile: ProfileModel?{ dependency.profile }
    var profileName: ReadOnlyCurrentValuePublisher<String>{ dependency.profileName }
    var profileDescription: ReadOnlyCurrentValuePublisher<String>{ dependency.profileDescription }
}

// MARK: - Builder

protocol ProfileEditMemojiBuildable: Buildable {
    func build(withListener listener: ProfileEditMemojiListener) -> ProfileEditMemojiRouting
}

final class ProfileEditMemojiBuilder: Builder<ProfileEditMemojiDependency>, ProfileEditMemojiBuildable {

    override init(dependency: ProfileEditMemojiDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileEditMemojiListener) -> ProfileEditMemojiRouting {
        let component = ProfileEditMemojiComponent(dependency: dependency)
        let viewController = ProfileEditMemojiViewController()
        let interactor = ProfileEditMemojiInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return ProfileEditMemojiRouter(interactor: interactor, viewController: viewController)
    }
}
