//
//  AppTutorialSplashInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialSplashRouting: ViewableRouting {
}

protocol AppTutorialSplashPresentable: Presentable {
    var listener: AppTutorialSplashPresentableListener? { get set }
    func setPage(page: Int)
}

protocol AppTutorialSplashListener: AnyObject {
    func appTutorailSplashDidFinish()
}

final class AppTutorialSplashInteractor: PresentableInteractor<AppTutorialSplashPresentable>, AppTutorialSplashInteractable, AppTutorialSplashPresentableListener {

    weak var router: AppTutorialSplashRouting?
    weak var listener: AppTutorialSplashListener?

    private var currentPage: Int
    
    
    // in constructor.
    override init(presenter: AppTutorialSplashPresentable) {
        self.currentPage = 0
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        showNextPage()
        
        Task { @MainActor in
            while currentPage <= 3 {
                try? await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000)) // 2second
                self.currentPage += 1
                self.showNextPage()
            }
        }
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func showNextPage(){
        if currentPage > 3{
            listener?.appTutorailSplashDidFinish()
            return
        }
        
        presenter.setPage(page: currentPage)
    }
}
