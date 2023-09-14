//
//  AppRootRouter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol AppRootInteractable: Interactable, RoutineHomeListener, RecordHomeListener, TimerHomeListener , ProfileHomeListener{
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable{
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    
    private let routineHomeBuildable : RoutineHomeBuildable
    private var routineHomeRouter : RoutineHomeRouting?
    
    private let recordHomeBuildable : RecordHomeBuildable
    private var recordHomeRouter : RecordHomeRouting?
    
    private let timerHomeBuildable : TimerHomeBuildable
    private var timerHomeRouter : TimerHomeRouting?
    
    private let profileHomeBuildable : ProfileHomeBuildable
    private var profileHomeRouter : ProfileHomeRouting?
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        routineHomeBuildable : RoutineHomeBuilder,
        recordHomeBuildable : RecordHomeBuilder,
        timerHomeBuildable : TimerHomeBuilder,
        profileHomeBuildable : ProfileHomeBuilder
    ) {
        self.routineHomeBuildable = routineHomeBuildable
        self.recordHomeBuildable = recordHomeBuildable
        self.timerHomeBuildable = timerHomeBuildable
        self.profileHomeBuildable = profileHomeBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
 
    func attachTabs() {
        let routineHomeRouting = routineHomeBuildable.build(withListener: interactor)
        let recordHomeRouting = recordHomeBuildable.build(withListener: interactor)
        let timerHomeRouting = timerHomeBuildable.build(withListener: interactor)
        let profileHomeRouting = profileHomeBuildable.build(withListener: interactor)
        
        attachChild(routineHomeRouting)
        attachChild(recordHomeRouting)
        attachChild(timerHomeRouting)
        attachChild(profileHomeRouting)
        
        
        
        let viewControllers = [
          NavigationControllerable(root: routineHomeRouting.viewControllable),
          NavigationControllerable(root: recordHomeRouting.viewControllable),
          NavigationControllerable(root: timerHomeRouting.viewControllable),
          NavigationControllerable(root: profileHomeRouting.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
