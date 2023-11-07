//
//  RoutineDataOfWeekInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import ModernRIBs

protocol RoutineDataOfWeekRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineDataOfWeekPresentable: Presentable {
    var listener: RoutineDataOfWeekPresentableListener? { get set }
    func setWeeks(_ viewModels: [RoutineDataOfWeekViewModel])
}

protocol RoutineDataOfWeekListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}



final class RoutineDataOfWeekInteractor: PresentableInteractor<RoutineDataOfWeekPresentable>, RoutineDataOfWeekInteractable, RoutineDataOfWeekPresentableListener {

    weak var router: RoutineDataOfWeekRouting?
    weak var listener: RoutineDataOfWeekListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineDataOfWeekPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        presenter.setWeeks(
            getDatesForThisWeek().map {
                RoutineDataOfWeekViewModel(
                    date: $0,
                    imageName: "checkmark.circle.fill",
                    done: Bool.random()
                )
            }
        )
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func getDatesForThisWeek() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        var beginningOfWeek: Date?
        var datesInThisWeek: [Date] = []
        
        // 현재 날짜를 기준으로 이번 주의 첫 번째 날 (일요일)을 찾기
        if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) {
            beginningOfWeek = calendar.date(byAdding: .day, value: 1, to: startOfWeek)
        }
        
        // 이번 주의 첫 번째 날짜부터 월요일까지의 날짜를 배열에 추가
        if let startDate = beginningOfWeek {
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                    datesInThisWeek.append(date)
                }
            }
        }
        
        return datesInThisWeek
    }
}
