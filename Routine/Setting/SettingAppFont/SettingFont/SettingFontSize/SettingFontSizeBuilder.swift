//
//  SettingFontSizeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingFontSizeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingFontSizeComponent: Component<SettingFontSizeDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SettingFontSizeBuildable: Buildable {
    func build(withListener listener: SettingFontSizeListener) -> SettingFontSizeRouting
}

final class SettingFontSizeBuilder: Builder<SettingFontSizeDependency>, SettingFontSizeBuildable {

    override init(dependency: SettingFontSizeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingFontSizeListener) -> SettingFontSizeRouting {
        let component = SettingFontSizeComponent(dependency: dependency)
        let viewController = SettingFontSizeViewController()
        let interactor = SettingFontSizeInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingFontSizeRouter(interactor: interactor, viewController: viewController)
    }
}
