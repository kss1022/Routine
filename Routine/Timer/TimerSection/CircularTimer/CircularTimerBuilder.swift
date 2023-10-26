//
//  CircularTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol CircularTimerDependency: Dependency {
    var detail: TimerSectionsModel{ get }
    var timer: AppTimer{ get }
}

final class CircularTimerComponent: Component<CircularTimerDependency>, CircularTimerInteractorDependency {
    var detail: TimerSectionsModel{ dependency.detail }
    var timer: AppTimer{ dependency.timer }    
}

// MARK: - Builder

protocol CircularTimerBuildable: Buildable {
    func build(withListener listener: CircularTimerListener) -> CircularTimerRouting
}

final class CircularTimerBuilder: Builder<CircularTimerDependency>, CircularTimerBuildable {

    override init(dependency: CircularTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CircularTimerListener) -> CircularTimerRouting {
        let component = CircularTimerComponent(dependency: dependency)
        let viewController = CircularTimerViewController()
        let interactor = CircularTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return CircularTimerRouter(interactor: interactor, viewController: viewController)
    }
}
