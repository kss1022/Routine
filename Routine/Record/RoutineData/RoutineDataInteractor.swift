//
//  RoutineDataInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs

protocol RoutineDataRouting: ViewableRouting {
    func attachRoutineDataOfWeek()
    func attachRoutineDataOfMonth()
    func attachRoutineDataOfYear()
    func attachRoutineTotalRecord()
}

protocol RoutineDataPresentable: Presentable {
    var listener: RoutineDataPresentableListener? { get set }
}

protocol RoutineDataListener: AnyObject {
    func routineDataDidMove()
}

final class RoutineDataInteractor: PresentableInteractor<RoutineDataPresentable>, RoutineDataInteractable, RoutineDataPresentableListener {

    weak var router: RoutineDataRouting?
    weak var listener: RoutineDataListener?

    // in constructor.
    override init(presenter: RoutineDataPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachRoutineDataOfWeek()
        router?.attachRoutineDataOfMonth()
        router?.attachRoutineDataOfYear()
        router?.attachRoutineTotalRecord()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didMove() {
        listener?.routineDataDidMove()
    }
    
}
