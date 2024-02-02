//
//  RecordBannerBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import ModernRIBs

protocol RecordBannerDependency: Dependency {
}

final class RecordBannerComponent: Component<RecordBannerDependency> {
}

// MARK: - Builder

protocol RecordBannerBuildable: Buildable {
    func build(withListener listener: RecordBannerListener) -> RecordBannerRouting
}

final class RecordBannerBuilder: Builder<RecordBannerDependency>, RecordBannerBuildable {

    override init(dependency: RecordBannerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordBannerListener) -> RecordBannerRouting {
        let component = RecordBannerComponent(dependency: dependency)
        let viewController = RecordBannerViewController()
        let interactor = RecordBannerInteractor(presenter: viewController)
        interactor.listener = listener
        return RecordBannerRouter(interactor: interactor, viewController: viewController)
    }
}
