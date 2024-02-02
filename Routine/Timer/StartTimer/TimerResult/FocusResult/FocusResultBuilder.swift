//
//  FocusResultBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol FocusResultDependency: Dependency {
}

final class FocusResultComponent: Component<FocusResultDependency> {
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
