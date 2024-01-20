//
//  SettingFontBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/18/23.
//

import ModernRIBs

protocol SettingFontDependency: Dependency {
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ get }
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class SettingFontComponent: Component<SettingFontDependency>, SettingFontSizeDependency, SettingTypefaceDependency {
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ dependency.isOSTypeface}
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ dependency.oSFontName }
}

// MARK: - Builder

protocol SettingFontBuildable: Buildable {
    func build(withListener listener: SettingFontListener) -> SettingFontRouting
}

final class SettingFontBuilder: Builder<SettingFontDependency>, SettingFontBuildable {

    override init(dependency: SettingFontDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingFontListener) -> SettingFontRouting {
        let component = SettingFontComponent(dependency: dependency)
        let viewController = SettingFontViewController()
        let interactor = SettingFontInteractor(presenter: viewController)
        interactor.listener = listener
        
        
        let settingFontSizeBuilder = SettingFontSizeBuilder(dependency: component)
        let settingTypefaceBuilder = SettingTypefaceBuilder(dependency: component)
        
        return SettingFontRouter(
            interactor: interactor,
            viewController: viewController,
            settingFontSizeBuildable: settingFontSizeBuilder,
            settingTypefaceBuildable: settingTypefaceBuilder
        )
    }
}
