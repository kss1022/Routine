//
//  TimerTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerTotalRecordRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerTotalRecordPresentable: Presentable {
    var listener: TimerTotalRecordPresentableListener? { get set }
    func setRecords(viewModels: [TimerTotalRecordListViewModel])
}

protocol TimerTotalRecordListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TimerTotalRecordInteractor: PresentableInteractor<TimerTotalRecordPresentable>, TimerTotalRecordInteractable, TimerTotalRecordPresentableListener {

    weak var router: TimerTotalRecordRouting?
    weak var listener: TimerTotalRecordListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerTotalRecordPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let viewModels = [
            TimerTotalRecordListViewModel(
                title: "Done this month",
                done: "\(Int.random(in: 0...30))"
            ),
            TimerTotalRecordListViewModel(
                title: "TotalDone",
                done: "\(Int.random(in: 0...30))"
            ),
            TimerTotalRecordListViewModel(
                title: "Current Streak",
                done: "\(Int.random(in: 0...30))"
            ),
            TimerTotalRecordListViewModel(
                title: "Best Streak",
                done: "\(Int.random(in: 0...30))"
            ),
            TimerTotalRecordListViewModel(
                title: "OverallRate",
                done: "\(Int.random(in: 0...30))%"
            ),
        ]
        
        self.presenter.setRecords(viewModels: viewModels)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
