//
//  SettingTypefaceBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingTypefaceDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class SettingTypefaceComponent: Component<SettingTypefaceDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
        let interactor = SettingTypefaceInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingTypefaceRouter(interactor: interactor, viewController: viewController)
    }
}
