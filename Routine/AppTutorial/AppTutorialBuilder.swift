//
//  AppTutorialBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialDependency: Dependency {
    
    var appTutorialViewController: ViewControllable { get }
    
    var routineApplicationService: RoutineApplicationService{ get }
    var profileApplicationService: ProfileApplicationService{ get }
    var timerApplicationService: TimerApplicationService{ get }
}

final class AppTutorialComponent: Component<AppTutorialDependency> , AppTutorialHomeDependency, AppTutorialRoutineDependency, AppTutorialProfileDependency, AppTutorialTimerDependency{
    
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var profileApplicationService: ProfileApplicationService{  dependency.profileApplicationService }    
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    
    
    var appTutorialViewController: ViewControllable {
        return dependency.appTutorialViewController
    }    
}

// MARK: - Builder

protocol AppTutorialBuildable: Buildable {
    func build(withListener listener: AppTutorialListener) -> AppTutorialRouting
}

final class AppTutorialBuilder: Builder<AppTutorialDependency>, AppTutorialBuildable {

    override init(dependency: AppTutorialDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialListener) -> AppTutorialRouting {
        let component = AppTutorialComponent(dependency: dependency)
        let interactor = AppTutorialInteractor()
        interactor.listener = listener
        
        let appTutorialHomeBuilder = AppTutorialHomeBuilder(dependency: component)
        let appTutorialRoutinBuilder = AppTutorialRoutineBuilder(dependency: component)
        let appTutorialProfileBuiler = AppTutorialProfileBuilder(dependency: component)
        let appTutorialTimerBuilder = AppTutorialTimerBuilder(dependency: component)
        
        return AppTutorialRouter(
            interactor: interactor,
            viewController: component.appTutorialViewController,
            appTutorailHomeBuildable: appTutorialHomeBuilder,
            appTutorialRoutineBuildable: appTutorialRoutinBuilder,
            appTutorialProfileBuildable: appTutorialProfileBuiler,
            appTutorialTimerBuildable: appTutorialTimerBuilder
        )
    }
}
