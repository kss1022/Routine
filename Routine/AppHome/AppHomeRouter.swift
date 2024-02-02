//
//  AppHomeRouter.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppHomeInteractable: Interactable, RoutineHomeListener, RecordHomeListener, TimerHomeListener , ProfileHomeListener  {
    var router: AppHomeRouting? { get set }
    var listener: AppHomeListener? { get set }
}

protocol AppHomeViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppHomeRouter: Router<AppHomeInteractable>, AppHomeRouting {

    
    private let routineHomeBuildable : RoutineHomeBuildable
    private var routineHomeRouter : ViewableRouting?
        
    private let timerHomeBuildable : TimerHomeBuildable
    private var timerHomeRouter : ViewableRouting?
    
    private let recordHomeBuildable : RecordHomeBuildable
    private var recordHomeRouter : ViewableRouting?
        
    private let profileHomeBuildable : ProfileHomeBuildable
    private var profileHomeRouter : ViewableRouting?
    
    
    
    init(
        interactor: AppHomeInteractable,
        viewController: AppHomeViewControllable,
        routineHomeBuildable : RoutineHomeBuildable,
        timerHomeBuildable : TimerHomeBuildable,
        recordHomeBuildable : RecordHomeBuildable,
        profileHomeBuildable : ProfileHomeBuildable
    ) {
        self.viewController = viewController
        self.routineHomeBuildable = routineHomeBuildable        
        self.timerHomeBuildable = timerHomeBuildable
        self.recordHomeBuildable = recordHomeBuildable
        self.profileHomeBuildable = profileHomeBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    

    func cleanupViews() {
    }
    
    func attachTabs() {
        let routineHomeRouting = routineHomeBuildable.build(withListener: interactor)
        let timerHomeRouting = timerHomeBuildable.build(withListener: interactor)
        let recordHomeRouting = recordHomeBuildable.build(withListener: interactor)
        let profileHomeRouting = profileHomeBuildable.build(withListener: interactor)
        
        attachChild(routineHomeRouting)
        attachChild(recordHomeRouting)
        attachChild(timerHomeRouting)
        attachChild(profileHomeRouting)
        
        let routineHome = NavigationControllerable(root: routineHomeRouting.viewControllable)
        let timerHome = NavigationControllerable(root: timerHomeRouting.viewControllable)
        let recordHome = NavigationControllerable(root: recordHomeRouting.viewControllable)
        let profileHome = NavigationControllerable(root: profileHomeRouting.viewControllable)
                    
        let viewControllers = [
          routineHome,
          timerHome,
          recordHome,
          profileHome
        ]
        
        recordHome.setLargeTitle()
        
        viewController.setViewControllers(viewControllers)
    }

    // MARK: - Private

    private let viewController: AppHomeViewControllable
}
