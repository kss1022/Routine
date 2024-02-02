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
}

protocol RoutineTopAcheiveListener: AnyObject {
    func routineTopAcheiveDidMove()
}

final class RoutineTopAcheiveInteractor: PresentableInteractor<RoutineTopAcheivePresentable>, RoutineTopAcheiveInteractable, RoutineTopAcheivePresentableListener {

    weak var router: RoutineTopAcheiveRouting?
    weak var listener: RoutineTopAcheiveListener?

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
    }
    
    
    func didMove() {
        listener?.routineTopAcheiveDidMove()
    }
}
