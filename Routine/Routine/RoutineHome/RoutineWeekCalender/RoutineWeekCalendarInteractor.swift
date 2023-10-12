//
//  RoutineWeekCalendarInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import Foundation
import ModernRIBs

protocol RoutineWeekCalendarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineWeekCalendarPresentable: Presentable {
    var listener: RoutineWeekCalendarPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineWeekCalendarListener: AnyObject {
    func routineWeekCalendarDidTap(date: Date)
}

final class RoutineWeekCalendarInteractor: PresentableInteractor<RoutineWeekCalendarPresentable>, RoutineWeekCalendarInteractable, RoutineWeekCalendarPresentableListener {

    weak var router: RoutineWeekCalendarRouting?
    weak var listener: RoutineWeekCalendarListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineWeekCalendarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func weekCalendarDidTap(date: Date) {
        listener?.routineWeekCalendarDidTap(date: date)
    }
    
}
