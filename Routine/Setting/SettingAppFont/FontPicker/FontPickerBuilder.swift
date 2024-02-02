//
//  FontPickerBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs

protocol FontPickerDependency: Dependency {
}

final class FontPickerComponent: Component<FontPickerDependency> {
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
