//
//  FocusResultBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol FocusResultDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FocusResultComponent: Component<FocusResultDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FocusResultBuildable: Buildable {
    func build(withListener listener: FocusResultListener) -> FocusResultRouting
}

final class FocusResultBuilder: Builder<FocusResultDependency>, FocusResultBuildable {

    override init(dependency: FocusResultDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FocusResultListener) -> FocusResultRouting {
        let component = FocusResultComponent(dependency: dependency)
        let viewController = FocusResultViewController()
        let interactor = FocusResultInteractor(presenter: viewController)
        interactor.listener = listener
        return FocusResultRouter(interactor: interactor, viewController: viewController)
    }
}
