//
//  TimerDataOfYearInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs

protocol TimerDataOfYearRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerDataOfYearPresentable: Presentable {
    var listener: TimerDataOfYearPresentableListener? { get set }
    func setComplets(_ dates: Set<Date>)
}

protocol TimerDataOfYearListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TimerDataOfYearInteractor: PresentableInteractor<TimerDataOfYearPresentable>, TimerDataOfYearInteractable, TimerDataOfYearPresentableListener {

    weak var router: TimerDataOfYearRouting?
    weak var listener: TimerDataOfYearListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerDataOfYearPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        let dates = [
            "2023-10-23",
            "2023-11-10",
            "2023-9-23",
            "2023-8-23",
            "2023-9-26",
            "2023-10-21",
            "2023-8-26",
        ].compactMap{ Formatter.recordDateFormatter().date(from: $0) }
                    
        presenter.setComplets(Set(dates))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
