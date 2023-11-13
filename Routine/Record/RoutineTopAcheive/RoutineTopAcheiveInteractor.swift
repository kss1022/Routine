//
//  RoutineTopAcheiveInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs

protocol RoutineTopAcheiveRouting: ViewableRouting {
    func attachTopAcheiveChart()
    func attachTopAcheiveTotalRecord()
}

protocol RoutineTopAcheivePresentable: Presentable {
    var listener: RoutineTopAcheivePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineTopAcheiveListener: AnyObject {
    func routineTopAcheiveDidMove()
}

final class RoutineTopAcheiveInteractor: PresentableInteractor<RoutineTopAcheivePresentable>, RoutineTopAcheiveInteractable, RoutineTopAcheivePresentableListener {

    weak var router: RoutineTopAcheiveRouting?
    weak var listener: RoutineTopAcheiveListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineTopAcheivePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTopAcheiveChart()
        router?.attachTopAcheiveTotalRecord()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func didMove() {
        listener?.routineTopAcheiveDidMove()
    }
}
