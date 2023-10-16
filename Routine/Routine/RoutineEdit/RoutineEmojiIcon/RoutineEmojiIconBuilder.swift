//
//  RoutineEmojiIconBuilder.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineEmojiIconDependency: Dependency {
    var routineRepository : RoutineRepository { get }
    var emojiSubject: CurrentValuePublisher<String>{ get }
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEmojiIconComponent: Component<RoutineEmojiIconDependency>, RoutineEmojiIconInteractorDependency {    
    var routineRepository : RoutineRepository { dependency.routineRepository }
    var emojiSubject: CurrentValuePublisher<String>{ dependency.emojiSubject }
    var detail: RoutineDetailModel?{ dependency.detail }
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
