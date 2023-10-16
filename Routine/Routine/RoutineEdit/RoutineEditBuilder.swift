//
//  RoutineEditBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
}

final class RoutineEditComponent: Component<RoutineEditDependency> , RoutineEditTitleDependency, RoutineTintDependency, RoutineEmojiIconDependency, RoutineEditRepeatDependency, RoutineEditReminderDependency, RoutineEditInteractorDependency{
    
    
    let routineId: UUID
    
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
    
    
    var detail: RoutineDetailModel?{ routineRepository.detail.value }

    var tint: ReadOnlyCurrentValuePublisher<String>{ tintSubject }
    lazy var  tintSubject = CurrentValuePublisher<String>( routineRepository.detail.value!.tint )
    
    var emoji: ReadOnlyCurrentValuePublisher<String>{ emojiSubject }
    lazy var  emojiSubject = CurrentValuePublisher<String>( routineRepository.detail.value!.emojiIcon )
    
    init(
        dependency: RoutineEditDependency,
        routineId: UUID
    ) {
        self.routineId = routineId
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RoutineEditBuildable: Buildable {
    func build(withListener listener: RoutineEditListener, routineId : UUID) -> RoutineEditRouting
}

final class RoutineEditBuilder: Builder<RoutineEditDependency>, RoutineEditBuildable {

    override init(dependency: RoutineEditDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditListener, routineId: UUID) -> RoutineEditRouting {
        let component = RoutineEditComponent(dependency: dependency, routineId: routineId)
        let viewController = RoutineEditViewController()
        let interactor = RoutineEditInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let routineEditTitleBuilder = RoutineEditTitleBuilder(dependency: component)
        let routineTintBuilder = RoutineTintBuilder(dependency: component)
        let routineEmojiIconBuilder = RoutineEmojiIconBuilder(dependency: component)
        let routineEditRepeatBuilder = RoutineEditRepeatBuilder(dependency: component)
        let routineEditReminderBuilder = RoutineEditReminderBuilder(dependency: component)
        
        return RoutineEditRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditTitleBuildable: routineEditTitleBuilder,
            routineTintBuildable: routineTintBuilder,
            routineEmojiIconBuildable: routineEmojiIconBuilder,
            routineEditRepeatBuidlable: routineEditRepeatBuilder,
            routineEditReminderBuildable: routineEditReminderBuilder
        )
    }
}
