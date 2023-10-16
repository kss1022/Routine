//
//  RoutineBasicInfoBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs

protocol RoutineBasicInfoDependency: Dependency {
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ get }
}

final class RoutineBasicInfoComponent: Component<RoutineBasicInfoDependency> , RoutineBasicInfoInteractorDependency{
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ dependency.routineDetail }
}

// MARK: - Builder

protocol RoutineBasicInfoBuildable: Buildable {
    func build(withListener listener: RoutineBasicInfoListener) -> RoutineBasicInfoRouting
}

final class RoutineBasicInfoBuilder: Builder<RoutineBasicInfoDependency>, RoutineBasicInfoBuildable {

    override init(dependency: RoutineBasicInfoDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RoutineBasicInfoListener) -> RoutineBasicInfoRouting {
        let component = RoutineBasicInfoComponent(dependency: dependency)
        let viewController = RoutineBasicInfoViewController()
        let interactor = RoutineBasicInfoInteractor(presenter: viewController, depdendency: component)
        interactor.listener = listener
        return RoutineBasicInfoRouter(interactor: interactor, viewController: viewController)
    }
}
