//
//  RoutineEmojiIconBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEmojiIconDependency: Dependency {
    var emojiSubject: CurrentValuePublisher<String>{ get }
    var routineReadModel: RoutineReadModelFacade{ get }
}

final class RoutineEmojiIconComponent: Component<RoutineEmojiIconDependency>, RoutineEmojiIconInteractorDependency {
    var emojiSubject: CurrentValuePublisher<String>{ dependency.emojiSubject }
    var routineReadModel: RoutineReadModelFacade{ dependency.routineReadModel }
}

// MARK: - Builder

protocol RoutineEmojiIconBuildable: Buildable {
    func build(withListener listener: RoutineEmojiIconListener) -> RoutineEmojiIconRouting
}

final class RoutineEmojiIconBuilder: Builder<RoutineEmojiIconDependency>, RoutineEmojiIconBuildable {

    override init(dependency: RoutineEmojiIconDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEmojiIconListener) -> RoutineEmojiIconRouting {
        let component = RoutineEmojiIconComponent(dependency: dependency)
        let viewController = RoutineEmojiIconViewController()
        let interactor = RoutineEmojiIconInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEmojiIconRouter(interactor: interactor, viewController: viewController)
    }
}
