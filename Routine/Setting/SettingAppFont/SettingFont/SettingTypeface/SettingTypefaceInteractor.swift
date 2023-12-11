//
//  SettingTypefaceInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingTypefaceRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingTypefacePresentable: Presentable {
    var listener: SettingTypefacePresentableListener? { get set }
    
    func setOsTypeface(_ viewModel: OsTypefaceListViewModel)
    func setAppTypeface(_ viewModel: [AppTypefaceListViewModel])
}

protocol SettingTypefaceListener: AnyObject {
    func settingTypefaceOsListDidTap()
    func settingTypefaceAppListDidTap(fontName: String)
}

final class SettingTypefaceInteractor: PresentableInteractor<SettingTypefacePresentable>, SettingTypefaceInteractable, SettingTypefacePresentableListener {

    weak var router: SettingTypefaceRouting?
    weak var listener: SettingTypefaceListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingTypefacePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let osModel = OsTypefaceListModel(
            isSelected: true,
            fontName: AppFontService.shared.fontName,
            imageName: "checkmark.circle",
            selectedImageName: "checkmark.circle.fill"
        ){ [weak self] in
            self?.listener?.settingTypefaceOsListDidTap()
        }
        
        
        
        let appFontModel = [
            AppTypefaceListModel(
                title: "Font1",
                isSelected: false,
                imageName: "checkmark.circle",
                selectedImageName: "checkmark.circle.fill"
            ){ [weak self] in
                self?.listener?.settingTypefaceAppListDidTap(fontName: "Font1")
            },
            AppTypefaceListModel(
                title: "Font2",
                isSelected: false,
                imageName: "checkmark.circle",
                selectedImageName: "checkmark.circle.fill"
            ){ [weak self] in
                self?.listener?.settingTypefaceAppListDidTap(fontName: "Font2")
            },
            AppTypefaceListModel(
                title: "Font2",
                isSelected: false,
                imageName: "checkmark.circle",
                selectedImageName: "checkmark.circle.fill"
            ){ [weak self] in
                self?.listener?.settingTypefaceAppListDidTap(fontName: "Font3")
            },
        ]
        
        presenter.setOsTypeface(OsTypefaceListViewModel(osModel))
        presenter.setAppTypeface(appFontModel.map(AppTypefaceListViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func selectFontButtonDidTap() {
        listener?.settingTypefaceOsListDidTap()
    }
}
