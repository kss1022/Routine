//
//  FocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusTimerRouting: ViewableRouting {
    func attachFocusRoundTimer()
}

protocol FocusTimerPresentable: Presentable {
    var listener: FocusTimerPresentableListener? { get set }
    func setTitle(title: String)
    func showFinishTimer()
}

protocol FocusTimerListener: AnyObject {
    func focusTimerDidTapClose()
}

protocol FocusTimerInteractorDependency{
    var model: TimerFocusModel{ get }
}

final class FocusTimerInteractor: PresentableInteractor<FocusTimerPresentable>, FocusTimerInteractable, FocusTimerPresentableListener {


    weak var router: FocusTimerRouting?
    weak var listener: FocusTimerListener?
    
    private let dependency: FocusTimerInteractorDependency
    
    // in constructor.
    init(
        presenter: FocusTimerPresentable,
        dependency: FocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachFocusRoundTimer()
        
        presenter.setTitle(title: dependency.model.timerName)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeButtonDidTap() {
        listener?.focusTimerDidTapClose()
    }
    
    // MARK: FocusRoundTimer
    func focusRoundTimerDidTapCancle() {
        listener?.focusTimerDidTapClose()
        
    }
    
    func focusRoundTimerDidFinish() {
        presenter.showFinishTimer()
    }
    
}