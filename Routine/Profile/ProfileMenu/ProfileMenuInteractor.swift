//
//  ProfileMenuInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileMenuRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileMenuPresentable: Presentable {
    var listener: ProfileMenuPresentableListener? { get set }
    func setMenus(_ viewModels: [ProfileMenuListViewModel])
}

protocol ProfileMenuListener: AnyObject {
    func profileMenuAlarmButtonDidTap()
    func profileMenuThemeButtonDidTap()
    func profileMenuFontButtonDidTap()
    func profileMenuAppIconButtonDidTap()
    
    func profileMenuGuideButtonDidTap()
    func profileMenuFeedbackButtonDidTap()
    func profileMenuAppInfoButtonDidTap()
}

final class ProfileMenuInteractor: PresentableInteractor<ProfileMenuPresentable>, ProfileMenuInteractable, ProfileMenuPresentableListener {
    
    weak var router: ProfileMenuRouting?
    weak var listener: ProfileMenuListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfileMenuPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        let listModels = [
            ProfileMenuListModel(
                title: "System Setting",
                menus: [
                    ProfileMenuModel(
                        imageName: "app.badge",
                        title: "Alarm") { [weak self] in
                            self?.listener?.profileMenuAlarmButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "circle.lefthalf.filled",
                        title: "Thema") { [weak self] in
                            self?.listener?.profileMenuThemeButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "textformat.size.larger",
                        title: "Font") { [weak self] in
                            self?.listener?.profileMenuFontButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "app.fill",
                        title: "AppIcon") { [weak self] in
                            self?.listener?.profileMenuAppIconButtonDidTap()
                        }
                ]
            ),
            ProfileMenuListModel(
                title: "Team",
                menus:  [
                    ProfileMenuModel(
                        imageName: "map",
                        title: "Guide") { [weak self] in
                            self?.listener?.profileMenuGuideButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "paperplane",
                        title: "Feedback") { [weak self] in
                            self?.listener?.profileMenuFeedbackButtonDidTap()
                        },
                    ProfileMenuModel(
                        imageName: "info",
                        title: "Info") { [weak self] in
                            self?.listener?.profileMenuAppInfoButtonDidTap()
                        },
                ]                
            )
        ]
        
        presenter.setMenus(listModels.map(ProfileMenuListViewModel.init))
        
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
