//
//  RoutineEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEditTitlePresentable: Presentable {
    var listener: RoutineEditTitlePresentableListener? { get set }

    func setTitle(emoji: String, routineName: String, routineDescription: String)
    func setEmoji(_ emoji: String)

}

protocol RoutineEditTitleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineEditTitleInteractorDependency{
    var emoji: ReadOnlyCurrentValuePublisher<String>{ get }
    var titleSubject : CurrentValuePublisher<String>{ get }
    var descriptionSubject : CurrentValuePublisher<String>{ get }
}

final class RoutineEditTitleInteractor: PresentableInteractor<RoutineEditTitlePresentable>, RoutineEditTitleInteractable, RoutineEditTitlePresentableListener {

    weak var router: RoutineEditTitleRouting?
    weak var listener: RoutineEditTitleListener?

    private var cancelables : Set<AnyCancellable>
    private let dependency : RoutineEditTitleInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineEditTitlePresentable,
        dependency: RoutineEditTitleInteractorDependency
    ) {
        self.cancelables = .init()
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()        
        presenter.setTitle(emoji: dependency.emoji.value, routineName: dependency.titleSubject.value, routineDescription: dependency.descriptionSubject.value)

        dependency.emoji
            .receive(on: DispatchQueue.main)
            .sink { [weak self] emoji in
                self?.presenter.setEmoji(emoji)
            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func setRoutineName(name: String) {
        dependency.titleSubject.send(name)
    }
    
    func setRoutineDescription(description: String) {
        dependency.descriptionSubject.send(description)
    }
}
