//
//  AppInfoInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs


protocol AppInfoRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppInfoPresentable: Presentable {
    var listener: AppInfoPresentableListener? { get set }
    func setMainInfo(_ viewModel: AppInfoMainViewModel)
    func setContact(_ viewModels: [AppInfoContactViewModel])
}

protocol AppInfoListener: AnyObject {
    func appInfoCloseButtonDidTap()
}

final class AppInfoInteractor: PresentableInteractor<AppInfoPresentable>, AppInfoInteractable, AppInfoPresentableListener {

    weak var router: AppInfoRouting?
    weak var listener: AppInfoListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppInfoPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let appInfoMananger = AppInfoManager.shared
        let appName = appInfoMananger.appName()
        let version = appInfoMananger.version()
        let buildVersion = appInfoMananger.buildVersion()
        
        let mainModel = AppInfoMainModel(
            imageName: "AppMainImage",
            version: "\(appName) \(version)   (\(buildVersion))",
            copyright: "© HG 🧑🏻‍💻"
        )
        
        
        presenter.setMainInfo(AppInfoMainViewModel(mainModel))
        
        
        
        
        let contanctModels = [
            AppInfoContactModel(
                emoji: "✉️",
                title: "Email contact to me",
                backgroundColor: "#CCFFCCFF",
                tapHandler: { URLSchemeManager.shared.openMailApp(email: "kss1022hhh@gmail.com") }
            ),
//            AppInfoContactModel(
//                emoji: "🧑🏻‍💻",
//                title: "My Github link",
//                backgroundColor: "#E5CCFFFF",
//                tapHandler: { URLSchemeManager.shared.openLink(url: "https://github.com/kss1022") }
//            )
        ]
        
        
        presenter.setContact(contanctModels.map(AppInfoContactViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeBarButtonDidTap() {
        listener?.appInfoCloseButtonDidTap()
    }
}
