//
//  ProfileStatBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileStatDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileStatComponent: Component<ProfileStatDependency>, ProfileRecordDependency, ProfileAcheiveDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileStatBuildable: Buildable {
    func build(withListener listener: ProfileStatListener) -> ProfileStatRouting
}

final class ProfileStatBuilder: Builder<ProfileStatDependency>, ProfileStatBuildable {

    override init(dependency: ProfileStatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileStatListener) -> ProfileStatRouting {
        let component = ProfileStatComponent(dependency: dependency)
        let viewController = ProfileStatViewController()
        let interactor = ProfileStatInteractor(presenter: viewController)
        interactor.listener = listener
        
        let profileRecordBuilder = ProfileRecordBuilder(dependency: component)
        let profileAcheiveBuilder = ProfileAcheiveBuilder(dependency: component)
        
        return ProfileStatRouter(
            interactor: interactor,
            viewController: viewController,
            profileRecordBuildable: profileRecordBuilder,
            profileAcheiveBuildable: profileAcheiveBuilder
        )
    }
}
