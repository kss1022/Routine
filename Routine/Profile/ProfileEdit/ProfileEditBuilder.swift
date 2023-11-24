//
//  ProfileEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import ModernRIBs

protocol ProfileEditDependency: Dependency {
    var profileApplicationService: ProfileApplicationService{ get }
    var profileRepository: ProfileRepository{ get }
}

final class ProfileEditComponent: Component<ProfileEditDependency>, ProfileEditNameDependency, ProfileEditDescriptionDependency, ProfileEditMemojiDependency , ProfileEditInteractorDependency{
    var profileApplicationService: ProfileApplicationService{ dependency.profileApplicationService }
    var profileRepository: ProfileRepository{ dependency.profileRepository }
    
    var profile: ProfileModel?{ profileRepository.profile.value }
    
    var profileName: ReadOnlyCurrentValuePublisher<String>{ profileNameSubject }
    lazy var profileNameSubject = CurrentValuePublisher<String>(profile?.profileName ?? "")
    
    var profileDescription: ReadOnlyCurrentValuePublisher<String>{ profileDescriptionSubject }
    lazy var profileDescriptionSubject =  CurrentValuePublisher<String>(profile?.profileDescription ?? "")
}

// MARK: - Builder

protocol ProfileEditBuildable: Buildable {
    func build(withListener listener: ProfileEditListener) -> ProfileEditRouting
}

final class ProfileEditBuilder: Builder<ProfileEditDependency>, ProfileEditBuildable {

    override init(dependency: ProfileEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileEditListener) -> ProfileEditRouting {
        let component = ProfileEditComponent(dependency: dependency)
        let viewController = ProfileEditViewController()
        let interactor = ProfileEditInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener

        let profileEditNameBuilder = ProfileEditNameBuilder(dependency: component)
        let profileEditDescriptionBuilder = ProfileEditDescriptionBuilder(dependency: component)
        let profileEditMemojiBuilder = ProfileEditMemojiBuilder(dependency: component)
        
        return ProfileEditRouter(
            interactor: interactor,
            viewController: viewController,
            profileEditNameBuildable: profileEditNameBuilder,
            profileEditDescriptionBuildable: profileEditDescriptionBuilder,
            profilEditMemojiBuildable: profileEditMemojiBuilder
        )
    }
}
