//
//  ProfileRecordBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileRecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ProfileRecordComponent: Component<ProfileRecordDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ProfileRecordBuildable: Buildable {
    func build(withListener listener: ProfileRecordListener) -> ProfileRecordRouting
}

final class ProfileRecordBuilder: Builder<ProfileRecordDependency>, ProfileRecordBuildable {

    override init(dependency: ProfileRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProfileRecordListener) -> ProfileRecordRouting {
        let component = ProfileRecordComponent(dependency: dependency)
        let viewController = ProfileRecordViewController()
        let interactor = ProfileRecordInteractor(presenter: viewController)
        interactor.listener = listener
        return ProfileRecordRouter(interactor: interactor, viewController: viewController)
    }
}
