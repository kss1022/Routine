//
//  AppTutorialMemojiBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialMemojiDependency: Dependency {
    var memojiTypeSubject: CurrentValuePublisher<MemojiType>{ get }
    var memojiStyleSubject: CurrentValuePublisher<MemojiStyle>{ get }
}

final class AppTutorialMemojiComponent: Component<AppTutorialMemojiDependency>, AppTutorialMemojiInteractorDependency {
    var memojiTypeSubject: CurrentValuePublisher<MemojiType>{ dependency.memojiTypeSubject }
    var memojiStyleSubject: CurrentValuePublisher<MemojiStyle>{ dependency.memojiStyleSubject }
}

// MARK: - Builder

protocol AppTutorialMemojiBuildable: Buildable {
    func build(withListener listener: AppTutorialMemojiListener) -> AppTutorialMemojiRouting
}

final class AppTutorialMemojiBuilder: Builder<AppTutorialMemojiDependency>, AppTutorialMemojiBuildable {

    override init(dependency: AppTutorialMemojiDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialMemojiListener) -> AppTutorialMemojiRouting {
        let component = AppTutorialMemojiComponent(dependency: dependency)
        let viewController = AppTutorialMemojiViewController()
        let interactor = AppTutorialMemojiInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return AppTutorialMemojiRouter(interactor: interactor, viewController: viewController)
    }
}
