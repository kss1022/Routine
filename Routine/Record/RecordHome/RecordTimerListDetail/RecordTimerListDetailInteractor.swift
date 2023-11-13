//
//  RecordTimerListDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs

protocol RecordTimerListDetailRouting: ViewableRouting {
    func attachTimerData()
    func detachTimerData()
}

protocol RecordTimerListDetailPresentable: Presentable {
    var listener: RecordTimerListDetailPresentableListener? { get set }
    func setTimerLists(_ viewModels: [RecordTimerListViewModel])
}

protocol RecordTimerListDetailListener: AnyObject {
    func recordTimerListDetailDidMove()
}

final class RecordTimerListDetailInteractor: PresentableInteractor<RecordTimerListDetailPresentable>, RecordTimerListDetailInteractable, RecordTimerListDetailPresentableListener {

    weak var router: RecordTimerListDetailRouting?
    weak var listener: RecordTimerListDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RecordTimerListDetailPresentable) {
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
    

    
    func didMove() {
        listener?.recordTimerListDetailDidMove()
    }
    
    
    //MARK: TimerDetail
    func timerListDidTap(routineId: UUID) {
        router?.attachTimerData()
    }
    
    func timerDataDidMove() {
        router?.detachTimerData()
    }
}
