//
//  RoutineDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs

protocol RoutineDetailRouting: ViewableRouting {
    func attachRoutineTitle()
    
}

protocol RoutineDetailPresentable: Presentable {
    var listener: RoutineDetailPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineDetailListener: AnyObject {
    func routineDetailDidMoved()
}

final class RoutineDetailInteractor: PresentableInteractor<RoutineDetailPresentable>, RoutineDetailInteractable, RoutineDetailPresentableListener {

    weak var router: RoutineDetailRouting?
    weak var listener: RoutineDetailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineDetailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachRoutineTitle()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMoved() {
        listener?.routineDetailDidMoved()
    }
}
