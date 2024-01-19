//
//  AppHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppHomeDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var appHomeViewController: AppHomeViewControllable { get }
    
    
    //MARK: ApplicationService
    var routineApplicationService: RoutineApplicationService{ get }
    var recordApplicationService: RecordApplicationService{ get }
    var timerApplicationService: TimerApplicationService{ get }
    var profileApplicationService: ProfileApplicationService{ get }
    
    //MARK: Repository
    var routineRepository: RoutineRepository{ get }
    var timerRepository: TimerRepository{ get }    
    var routineRecordRepository: RoutineRecordRepository{ get }
    var profileRepository: ProfileRepository{ get }
    var reminderRepository: ReminderRepository{ get }
    
    
    var createRoutineBuildable: CreateRoutineBuildable{ get }
    
    var startTimerViewController: ViewControllable{ get }
    var timerEditViewController: ViewControllable{ get }
}

final class AppHomeComponent: Component<AppHomeDependency>, RoutineHomeDependency, RecordHomeDependency, TimerHomeDependency, ProfileHomeDependency, CreateRoutineDependency, AppRootInteractorDependency {
    

    var appHomeViewController: AppHomeViewControllable {
        return dependency.appHomeViewController
    }

    //MARK: ApplicationService
    var routineApplicationService: RoutineApplicationService{ dependency.routineApplicationService }
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    var timerApplicationService: TimerApplicationService{ dependency.timerApplicationService }
    var profileApplicationService: ProfileApplicationService{ dependency.profileApplicationService }
    
    //MARK: Repository
    var routineRepository: RoutineRepository{ dependency.routineRepository }
    var timerRepository: TimerRepository{ dependency.timerRepository }
    var routineRecordRepository: RoutineRecordRepository{ dependency.routineRecordRepository }
    var profileRepository: ProfileRepository{ dependency.profileRepository }
    var reminderRepository: ReminderRepository{  dependency.reminderRepository }
    
    //MARK: Buildable
    var createRoutineBuildable: CreateRoutineBuildable{ dependency.createRoutineBuildable }
    
    //MARK: ViewControllable
    var startTimerViewController: ViewControllable{ dependency.startTimerViewController }
    var timerEditViewController: ViewControllable{ dependency.timerEditViewController }
}

// MARK: - Builder

protocol AppHomeBuildable: Buildable {
    func build(withListener listener: AppHomeListener) -> AppHomeRouting
}

final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {

    override init(dependency: AppHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppHomeListener) -> AppHomeRouting {
        let component = AppHomeComponent(dependency: dependency)
        let interactor = AppHomeInteractor()
        interactor.listener = listener
        
        
        let routineBuildable = RoutineHomeBuilder(dependency: component)
        let timerBuildable = TimerHomeBuilder(dependency: component)
        let recordHomeBuildable = RecordHomeBuilder(dependency: component)
        let profileBuildable = ProfileHomeBuilder(dependency: component)
        
        
        
        return AppHomeRouter(
            interactor: interactor,
            viewController: component.appHomeViewController,
            routineHomeBuildable: routineBuildable,            
            timerHomeBuildable: timerBuildable,
            recordHomeBuildable: recordHomeBuildable,
            profileHomeBuildable: profileBuildable
        )
    }
}
