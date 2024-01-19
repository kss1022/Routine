//
//  RoutineTopAcheiveBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveDependency: Dependency {
    var routineRecordRepository: RoutineRecordRepository{ get }
}

final class RoutineTopAcheiveComponent: Component<RoutineTopAcheiveDependency>, RoutineTopAcheiveChartDependency, RoutineTopAcheiveTotalRecordDependency {
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ routineRecordRepository.topAcheive }
}

// MARK: - Builder

protocol RoutineTopAcheiveBuildable: Buildable {
    func build(withListener listener: RoutineTopAcheiveListener) -> RoutineTopAcheiveRouting
}

final class RoutineTopAcheiveBuilder: Builder<RoutineTopAcheiveDependency>, RoutineTopAcheiveBuildable {

    override init(dependency: RoutineTopAcheiveDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineTopAcheiveListener) -> RoutineTopAcheiveRouting {
        let component = RoutineTopAcheiveComponent(dependency: dependency)
        let viewController = RoutineTopAcheiveViewController()
        let interactor = RoutineTopAcheiveInteractor(presenter: viewController)
        interactor.listener = listener
        
        let routineTopAcheiveBuilder = RoutineTopAcheiveChartBuilder(dependency: component)
        let routineTopAcheiveTotalRecordBuilder = RoutineTopAcheiveTotalRecordBuilder(dependency: component)
        
        return RoutineTopAcheiveRouter(
            interactor: interactor,
            viewController: viewController,
            routineTopAcheiveChartBuildable: routineTopAcheiveBuilder,
            routineTopAcheiveTotalRecordBuildable: routineTopAcheiveTotalRecordBuilder
        )
    }
}
