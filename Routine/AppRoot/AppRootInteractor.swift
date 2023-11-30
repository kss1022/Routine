//
//  AppRootInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import Foundation

protocol AppRootRouting: ViewableRouting {
    func attachAppHome()
    func attachAppTutorial()
}

protocol AppRootPresentable: Presentable {
    var listener: AppRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol AppRootInteractorDependency{
}

final class AppRootInteractor: PresentableInteractor<AppRootPresentable>, AppRootInteractable, AppRootPresentableListener , URLHandler{
    
    weak var router: AppRootRouting?
    weak var listener: AppRootListener?
    
    private let dependency: AppRootInteractorDependency
    private let prefrenceStorage: PreferenceStorage
    // in constructor.
    init(
        presenter: AppRootPresentable,
        dependency: AppRootInteractorDependency
    ) {
        self.dependency = dependency
        self.prefrenceStorage = PreferenceStorage.shared
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    
        if prefrenceStorage.showAppTutorials{
            router?.attachAppHome()
        }else{
            router?.attachAppTutorial()
        }
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func handle(_ url: URL) {
        //Handle Url
        Log.v("Need To URL Hadle \(url)")
    }
    
    func appTutorailDidFinish() {
        prefrenceStorage.showAppTutorials = true
        router?.attachAppHome()
    }
}

