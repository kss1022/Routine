//
//  FeedbackMailBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol FeedbackMailDependency: Dependency {
}

final class FeedbackMailComponent: Component<FeedbackMailDependency> {
}

// MARK: - Builder

protocol FeedbackMailBuildable: Buildable {
    func build(withListener listener: FeedbackMailListener) -> FeedbackMailRouting
}

final class FeedbackMailBuilder: Builder<FeedbackMailDependency>, FeedbackMailBuildable {

    override init(dependency: FeedbackMailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedbackMailListener) -> FeedbackMailRouting {
        let component = FeedbackMailComponent(dependency: dependency)
        let viewController = FeedbackMailViewController()
        let interactor = FeedbackMailInteractor(presenter: viewController)
        interactor.listener = listener
        return FeedbackMailRouter(interactor: interactor, viewController: viewController)
    }
}
