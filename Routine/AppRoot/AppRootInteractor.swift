//
//  AppRootInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import Foundation

protocol AppRootRouting: ViewableRouting {
    func attachTabs()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol AppRootInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener , URLHandler{
    
    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    
    private let dependency: AppRootInteractorDependency
    
    // in constructor.
    init(
        presenter: AppRootPresentable,
        dependency: AppRootInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{
            try? await initTimer()
        }
        
        router?.attachTabs()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func handle(_ url: URL) {
        //Handle Url
        Log.v("Need To URL Hadle \(url)")
    }
    
    
    func initTimer() async throws{
        let preference = PreferenceStorage.shared
        if preference.timerSetup{
            return
        }
        
        try await TimerSetup(
            timerApplicationService: dependency.timerApplicationService,
            timerRepository: dependency.timerRepository
        ).initTimer()
        preference.timerSetup = true
    }
}

