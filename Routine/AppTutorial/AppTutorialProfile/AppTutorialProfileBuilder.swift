//
//  AppTutorialProfileBuilder.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialProfileDependency: Dependency {
    var profileApplicationService: ProfileApplicationService{ get }
}

final class AppTutorialProfileComponent: Component<AppTutorialProfileDependency>, AppTutorialMemojiDependency, AppTutorialProfileInteractorDependency {
    
    
    var profileApplicationService: ProfileApplicationService{ dependency.profileApplicationService }
    
    
    var memojiType: ReadOnlyCurrentValuePublisher<MemojiType>{ memojiTypeSubject }
    var memojiTypeSubject = CurrentValuePublisher<MemojiType>(MemojiType.emoji("🤯"))
    
    var memojiStyle: ReadOnlyCurrentValuePublisher<MemojiStyle>{ memojiStyleSubject }
    var memojiStyleSubject = CurrentValuePublisher<MemojiStyle>(MemojiStyle(topColor: "#A8ADBAFF", bottomColor: "#878C96FF"))
}

// MARK: - Builder

protocol AppTutorialProfileBuildable: Buildable {
    func build(withListener listener: AppTutorialProfileListener) -> AppTutorialProfileRouting
}

final class AppTutorialProfileBuilder: Builder<AppTutorialProfileDependency>, AppTutorialProfileBuildable {

    override init(dependency: AppTutorialProfileDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppTutorialProfileListener) -> AppTutorialProfileRouting {
        let component = AppTutorialProfileComponent(dependency: dependency)
        let viewController = AppTutorialProfileViewController()
        let interactor = AppTutorialProfileInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let appTutorialSetMemojiBuildable = AppTutorialMemojiBuilder(dependency: component)
        
        return AppTutorialProfileRouter(
            interactor: interactor,
            viewController: viewController,
            appTutorialSetMemojiBuildable: appTutorialSetMemojiBuildable
        )
    }
}
