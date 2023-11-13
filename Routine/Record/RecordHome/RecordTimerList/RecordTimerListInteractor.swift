//
//  RecordTimerListInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import Foundation
import ModernRIBs

protocol RecordTimerListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordTimerListPresentable: Presentable {
    var listener: RecordTimerListPresentableListener? { get set }
    func setTimerLists(_ viewModels: [RecordTimerListViewModel])
}

protocol RecordTimerListListener: AnyObject {
    func recordTimerListTitleButtonDidTap()
    func recordTimerListDidTap(timerId: UUID)
}

final class RecordTimerListInteractor: PresentableInteractor<RecordTimerListPresentable>, RecordTimerListInteractable, RecordTimerListPresentableListener {
    
    weak var router: RecordTimerListRouting?
    weak var listener: RecordTimerListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RecordTimerListPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let viewModels = [
            RecordTimerListViewModel(
                timerId: UUID(),
                name: "My Focus Timer",
                emojiIcon: "📕",
                duration: "2022.08.21 ~ 2023.11.10",
                done: Bool.random()
            ),
            RecordTimerListViewModel(
                timerId: UUID(),
                name: "My Focus Timer",
                emojiIcon: "📗",
                duration: "2022.08.21 ~ 2023.11.10",
                done: Bool.random()
            ),
            RecordTimerListViewModel(
                timerId: UUID(),
                name: "My Focus Timer",
                emojiIcon: "📙",
                duration: "2022.08.21 ~ 2023.11.10",
                done: Bool.random()
            ),
            RecordTimerListViewModel(
                timerId: UUID(),
                name: "My Focus Timer",
                emojiIcon: "📘",
                duration: "2022.08.21 ~ 2023.11.10",
                done: Bool.random()
            ),
        ]
        
        presenter.setTimerLists(viewModels)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func titleButtonDidTap() {
        listener?.recordTimerListTitleButtonDidTap()
    }
    
    func timerListDidTap(timerId: UUID) {
        listener?.recordTimerListDidTap(timerId: timerId)
    }
}
