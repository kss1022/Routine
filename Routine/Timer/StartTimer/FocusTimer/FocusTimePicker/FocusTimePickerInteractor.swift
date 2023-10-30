//
//  FocusTimePickerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs

protocol FocusTimePickerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FocusTimePickerPresentable: Presentable {
    var listener: FocusTimePickerPresentableListener? { get set }
    func setCountdown(countdown: Int)
}

protocol FocusTimePickerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol FocusTimePickerInteractorDependency{
    var model: TimerFocusModel{ get }
    var timer: AppFocusTimer{ get }
}

final class FocusTimePickerInteractor: PresentableInteractor<FocusTimePickerPresentable>, FocusTimePickerInteractable, FocusTimePickerPresentableListener {

    weak var router: FocusTimePickerRouting?
    weak var listener: FocusTimePickerListener?

    private let dependency: FocusTimePickerInteractorDependency
    
    // in constructor.
    init(
        presenter: FocusTimePickerPresentable,
        dependency: FocusTimePickerInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                        
        presenter.setCountdown(countdown: dependency.model.timerCountdown)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
