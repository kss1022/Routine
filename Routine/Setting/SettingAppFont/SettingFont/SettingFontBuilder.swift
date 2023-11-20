//
//  SettingFontBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/18/23.
//

import ModernRIBs

protocol SettingFontDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingFontComponent: Component<SettingFontDependency>, SettingFontSizeDependency, SettingTypefaceDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
