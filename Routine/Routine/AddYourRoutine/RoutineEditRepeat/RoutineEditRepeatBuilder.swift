//
//  RoutineEditRepeatBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditRepeatDependency: Dependency {
    var repeatSegmentTypeSubject: CurrentValuePublisher<RepeatSegmentType>{ get }
    var repeatDoItOnceControlValueSubject: CurrentValuePublisher<Date>{ get }
    var repeatWeeklyControlValueSubject: CurrentValuePublisher<Set<Weekly>>{ get }
    var repeatMonthlyControlValueSubject: CurrentValuePublisher<Set<Monthly>>{ get }
    
}

final class RoutineEditRepeatComponent: Component<RoutineEditRepeatDependency>, RoutineEditRepeatInteractorDependency {
    var repeatSegmentTypeSubject: CurrentValuePublisher<RepeatSegmentType>{ dependency.repeatSegmentTypeSubject }
    var repeatDoItOnceControlValueSubject: CurrentValuePublisher<Date>{ dependency.repeatDoItOnceControlValueSubject }
    var repeatWeeklyControlValueSubject: CurrentValuePublisher<Set<Weekly>>{ dependency.repeatWeeklyControlValueSubject }
    var repeatMonthlyControlValueSubject: CurrentValuePublisher<Set<Monthly>>{ dependency.repeatMonthlyControlValueSubject }
}

// MARK: - Builder

protocol RoutineEditRepeatBuildable: Buildable {
    func build(withListener listener: RoutineEditRepeatListener) -> RoutineEditRepeatRouting
}

final class RoutineEditRepeatBuilder: Builder<RoutineEditRepeatDependency>, RoutineEditRepeatBuildable {

    override init(dependency: RoutineEditRepeatDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineEditRepeatListener) -> RoutineEditRepeatRouting {
        let component = RoutineEditRepeatComponent(dependency: dependency)
        let viewController = RoutineEditRepeatViewController()
        let interactor = RoutineEditRepeatInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return RoutineEditRepeatRouter(interactor: interactor, viewController: viewController)
    }
}
