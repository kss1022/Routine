//
//  SettingFontSizeBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingFontSizeDependency: Dependency {
    var isOsFontSize: ReadOnlyCurrentValuePublisher<Bool>{ get }
    var fontSize: ReadOnlyCurrentValuePublisher<AppFontSize>{ get }
}

final class SettingFontSizeComponent: Component<SettingFontSizeDependency>, SettingFontSizeInteractorDependency {
    var isOsFontSize: ReadOnlyCurrentValuePublisher<Bool>{ dependency.isOsFontSize }
    var fontSize: ReadOnlyCurrentValuePublisher<AppFontSize>{ dependency.fontSize }
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
        let interactor = SettingFontSizeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SettingFontSizeRouter(interactor: interactor, viewController: viewController)
    }
}
