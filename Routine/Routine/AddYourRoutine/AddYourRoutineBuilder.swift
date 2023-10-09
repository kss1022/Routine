//
//  AddYourRoutineBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import Foundation
import ModernRIBs

protocol AddYourRoutineDependency: Dependency {
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository : RoutineRepository { get }
}

final class AddYourRoutineComponent: Component<AddYourRoutineDependency>, RoutineEditTitleDependency, RoutineTintDependency, RoutineEmojiIconDependency, AddYourRoutineInteractorDependency, RoutineEditRepeatDependency{
        
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var routineRepository : RoutineRepository { dependency.routineRepository }
    
    
    var title: ReadOnlyCurrentValuePublisher<String>{ titleSubject}
    let titleSubject = CurrentValuePublisher<String>("")
    
    var description: ReadOnlyCurrentValuePublisher<String>{ descriptionSubject }
    let descriptionSubject = CurrentValuePublisher<String>("")
            
    var repeatSegmentType: ReadOnlyCurrentValuePublisher<RepeatSegmentType>{ repeatSegmentTypeSubject }
    let repeatSegmentTypeSubject = CurrentValuePublisher<RepeatSegmentType>(.none)
    
    var repeatDoItOnceControlValue: ReadOnlyCurrentValuePublisher<Date>{ repeatDoItOnceControlValueSubject }
    var repeatDoItOnceControlValueSubject = CurrentValuePublisher<Date>( .init() )
    
    var repeatWeeklyControlValue: ReadOnlyCurrentValuePublisher<Set<Weekly>>{ repeatWeeklyControlValueSubject }
    let repeatWeeklyControlValueSubject = CurrentValuePublisher<Set<Weekly>>(.init())
    
    var repeatMonthlyControlValue: ReadOnlyCurrentValuePublisher<Set<Monthly>>{ repeatMonthlyControlValueSubject }
    let repeatMonthlyControlValueSubject = CurrentValuePublisher<Set<Monthly>>(.init())
                

    var tint: ReadOnlyCurrentValuePublisher<String>{ tintSubject }
    let tintSubject = CurrentValuePublisher<String>("#FFCCCCFF")
    
    var emoji: ReadOnlyCurrentValuePublisher<String>{ emojiSubject }
    let emojiSubject = CurrentValuePublisher<String>("⭐️")
    
    
}

// MARK: - Builder

protocol AddYourRoutineBuildable: Buildable {
    func build(withListener listener: AddYourRoutineListener) -> AddYourRoutineRouting
}

final class AddYourRoutineBuilder: Builder<AddYourRoutineDependency>, AddYourRoutineBuildable {
    
    override init(dependency: AddYourRoutineDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: AddYourRoutineListener) -> AddYourRoutineRouting {
        let component = AddYourRoutineComponent(dependency: dependency)
        let viewController = AddYourRoutineViewController()
        let interactor = AddYourRoutineInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        
        let routineEditTitleBuilder = RoutineEditTitleBuilder(dependency: component)
        let routineTintBuilder = RoutineTintBuilder(dependency: component)
        let routineEmojiIconBuilder = RoutineEmojiIconBuilder(dependency: component)
        let routineEditRepeatBuilder = RoutineEditRepeatBuilder(dependency: component)

        
        return AddYourRoutineRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditTitleBuildable: routineEditTitleBuilder,
            routineTintBuildable: routineTintBuilder,
            routineEmojiIconBuildable: routineEmojiIconBuilder,
            routineEditRepeatBuildable: routineEditRepeatBuilder
        )
    }
}
