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
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class AddYourRoutineComponent: Component<AddYourRoutineDependency>, RoutineEditTitleDependency, RoutineEditStyleDependency, RoutineEditRepeatDependency, RoutineEditReminderDependency, AddYourRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var routineRepository : RoutineRepository { dependency.routineRepository }
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    
    var detail: RoutineDetailModel?{ nil }
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
        let routineEditStyleBuilder = RoutineEditStyleBuilder(dependency: component)
        let routineEditRepeatBuilder = RoutineEditRepeatBuilder(dependency: component)
        let routineEditReminderBulider = RoutineEditReminderBuilder(dependency: component)
        
        return AddYourRoutineRouter(
            interactor: interactor,
            viewController: viewController,
            routineEditTitleBuildable: routineEditTitleBuilder,
            routineEditStyleBuildable: routineEditStyleBuilder,
            routineEditRepeatBuildable: routineEditRepeatBuilder,
            routineEditReminderBuildable: routineEditReminderBulider
        )
    }
}
