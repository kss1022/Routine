//
//  RecordHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RecordHomeComponent: Component<RecordHomeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol RecordHomeBuildable: Buildable {
    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting
}

final class RecordHomeBuilder: Builder<RecordHomeDependency>, RecordHomeBuildable {

    override init(dependency: RecordHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting {
        let component = RecordHomeComponent(dependency: dependency)
        let viewController = RecordHomeViewController()
        let interactor = RecordHomeInteractor(presenter: viewController)
        interactor.listener = listener
        return RecordHomeRouter(interactor: interactor, viewController: viewController)
    }
}
