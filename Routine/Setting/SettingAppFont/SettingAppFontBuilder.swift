//
//  SettingAppFontBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingAppFontComponent: Component<SettingAppFontDependency>,FontPickerDependency, FontPreviewDependency, SettingFontDependency, SettingAppFontInteractorDependency {
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ isOSTypefcaeSubject }
    var isOSTypefcaeSubject = CurrentValuePublisher<Bool>(AppFontService.shared.isOSTypeface)
    
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ oSFontNameSubject }
    var oSFontNameSubject = CurrentValuePublisher<String>(AppFontService.shared.fontName)
}

// MARK: - Builder

protocol SettingAppFontBuildable: Buildable {
    func build(withListener listener: SettingAppFontListener) -> SettingAppFontRouting
}

final class SettingAppFontBuilder: Builder<SettingAppFontDependency>, SettingAppFontBuildable {

    override init(dependency: SettingAppFontDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingAppFontListener) -> SettingAppFontRouting {
        let component = SettingAppFontComponent(dependency: dependency)
        let viewController = SettingAppFontViewController()
        let interactor = SettingAppFontInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let fontPickerBuilder = FontPickerBuilder(dependency: component)
        
        let fontPreviewBuilder = FontPreviewBuilder(dependency: component)
        let settingFontBuilder = SettingFontBuilder(dependency: component)
        
        return SettingAppFontRouter(
            interactor: interactor,
            viewController: viewController,
            fontPickerBuildable: fontPickerBuilder,
            fontPreviewBuildable: fontPreviewBuilder,
            settingFontBuildable: settingFontBuilder
        )
    }
}
