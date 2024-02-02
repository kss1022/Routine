//
//  ProfileMenuInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileMenuRouting: ViewableRouting {
}

protocol ProfileMenuPresentable: Presentable {
    var listener: ProfileMenuPresentableListener? { get set }
    func setMenus(_ viewModels: [ProfileMenuListViewModel])
    func setMenu(_ viewModel: ProfileRequestReviewListViewModel)
}

protocol ProfileMenuListener: AnyObject {
    func profileMenuAlarmButtonDidTap()
    func profileMenuThemeButtonDidTap()
    func profileMenuFontButtonDidTap()
    func profileMenuAppIconButtonDidTap()
    
    func profileMenuGuideButtonDidTap()
    func profileMenuFeedbackButtonDidTap()
    func profileMenuAppInfoButtonDidTap()
    
    func profileMenuRequestReviewDidTap()
}

final class ProfileMenuInteractor: PresentableInteractor<ProfileMenuPresentable>, ProfileMenuInteractable, ProfileMenuPresentableListener {
    
    weak var router: ProfileMenuRouting?
    weak var listener: ProfileMenuListener?
    
    // in constructor.
    override init(presenter: ProfileMenuPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        let listModels = [
            ProfileMenuListModel(
                title: "system_setting".localized(tableName: "Profile"),
                menus: [
                    ProfileMenuModel(
                        imageName: "app.badge",
                        title: "alarm".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuAlarmButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "circle.lefthalf.filled",
                        title: "theme".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuThemeButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "textformat.size.larger",
                        title: "font".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuFontButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "app.fill",
                        title: "appIcon".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuAppIconButtonDidTap()
                        }
                ]
            ),
            ProfileMenuListModel(
                title: "team".localized(tableName: "Profile"),
                menus:  [
//                    ProfileMenuModel(
//                        imageName: "map",
//                        title: "guide".localized(tableName: "Profile")) { [weak self] in
//                            self?.listener?.profileMenuGuideButtonDidTap()
//                        },
                    ProfileMenuModel(
                        imageName: "paperplane",
                        title: "feedback".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuFeedbackButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "info",
                        title: "info".localized(tableName: "Profile")) { [weak self] in
                            self?.listener?.profileMenuAppInfoButtonDidTap()
                        },
                ]                
            )
        ]
        
        let reqeustReviewModel = ProfileRequestReviewListModel(
            title: "request_review".localized(tableName: "Profile"),
            backgroundColor: "#8898EFFF") { [weak self] in
                self?.listener?.profileMenuRequestReviewDidTap()
            }
        
        presenter.setMenus(listModels.map(ProfileMenuListViewModel.init))
        presenter.setMenu(ProfileRequestReviewListViewModel(reqeustReviewModel))        
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}
