//
//  SettingTypefaceBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingTypefaceDependency: Dependency {
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ get}
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class SettingTypefaceComponent: Component<SettingTypefaceDependency>, SettingTypefaceInteractorDependency {
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ dependency.isOSTypeface }
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ dependency.oSFontName }
}

// MARK: - Builder

protocol SettingTypefaceBuildable: Buildable {
    func build(withListener listener: SettingTypefaceListener) -> SettingTypefaceRouting
}

final class SettingTypefaceBuilder: Builder<SettingTypefaceDependency>, SettingTypefaceBuildable {

    override init(dependency: SettingTypefaceDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SettingTypefaceListener) -> SettingTypefaceRouting {
        let component = SettingTypefaceComponent(dependency: dependency)
        let viewController = SettingTypefaceViewController()
        let interactor = SettingTypefaceInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SettingTypefaceRouter(interactor: interactor, viewController: viewController)
    }
}
