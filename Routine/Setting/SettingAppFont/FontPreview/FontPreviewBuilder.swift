//
//  FontPreviewBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol FontPreviewDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FontPreviewComponent: Component<FontPreviewDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FontPreviewBuildable: Buildable {
    func build(withListener listener: FontPreviewListener) -> FontPreviewRouting
}

final class FontPreviewBuilder: Builder<FontPreviewDependency>, FontPreviewBuildable {

    override init(dependency: FontPreviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FontPreviewListener) -> FontPreviewRouting {
        let component = FontPreviewComponent(dependency: dependency)
        let viewController = FontPreviewViewController()
        let interactor = FontPreviewInteractor(presenter: viewController)
        interactor.listener = listener
        return FontPreviewRouter(interactor: interactor, viewController: viewController)
    }
}
