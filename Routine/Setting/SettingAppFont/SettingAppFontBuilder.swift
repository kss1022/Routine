//
//  SettingAppFontBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol SettingAppFontDependency: Dependency {
}

final class SettingAppFontComponent: Component<SettingAppFontDependency>,FontPickerDependency, FontPreviewDependency, SettingFontDependency, SettingAppFontInteractorDependency {
    //typeface
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ isOSTypefcaeSubject }
    var isOSTypefcaeSubject = CurrentValuePublisher<Bool>(AppFontService.shared.isOSTypeface)
    
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ oSFontNameSubject }
    var oSFontNameSubject = CurrentValuePublisher<String>(AppFontService.shared.fontName)
    
    //fontsize
    var isOsFontSize: ReadOnlyCurrentValuePublisher<Bool>{ isOsFontSizeSubject }
    var isOsFontSizeSubject = CurrentValuePublisher<Bool>(AppFontService.shared.isOSFontSize)
    
    var fontSize: ReadOnlyCurrentValuePublisher<AppFontSize>{ fontSizeSubject }
    var fontSizeSubject = CurrentValuePublisher<AppFontSize>(AppFontService.shared.fontSize)
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
