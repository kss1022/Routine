//
//  RoutineWeekCalendarInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import Foundation
import ModernRIBs

protocol RoutineWeekCalendarRouting: ViewableRouting {
}

protocol RoutineWeekCalendarPresentable: Presentable {
    var listener: RoutineWeekCalendarPresentableListener? { get set }
}

protocol RoutineWeekCalendarListener: AnyObject {
    func routineWeekCalendarDidTap(date: Date)
}

final class RoutineWeekCalendarInteractor: PresentableInteractor<RoutineWeekCalendarPresentable>, RoutineWeekCalendarInteractable, RoutineWeekCalendarPresentableListener {

    weak var router: RoutineWeekCalendarRouting?
    weak var listener: RoutineWeekCalendarListener?

    // in constructor.
    override init(presenter: RoutineWeekCalendarPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func weekCalendarDidTap(date: Date) {
        listener?.routineWeekCalendarDidTap(date: date)
    }
    
}
