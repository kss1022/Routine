//
//  FontPickerBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs

protocol FontPickerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FontPickerComponent: Component<FontPickerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FontPickerBuildable: Buildable {
    func build(withListener listener: FontPickerListener) -> FontPickerRouting
}

final class FontPickerBuilder: Builder<FontPickerDependency>, FontPickerBuildable {

    override init(dependency: FontPickerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FontPickerListener) -> FontPickerRouting {
        let component = FontPickerComponent(dependency: dependency)
        let viewController = FontPickerViewController()
        let interactor = FontPickerInteractor(presenter: viewController)
        interactor.listener = listener
        return FontPickerRouter(interactor: interactor, viewController: viewController)
    }
}
